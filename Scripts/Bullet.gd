extends Area2D

enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM, CHAIN_BEAM, GRAPPLE, REMOTE, HARPOON }
enum Effect { NONE, EXPLOSION, SLOW, PIN, PULL_ENEMY, PULL_SELF }

var speed = 1000.0
var damage = 25.0
var shooter = null 

var b_trait: Trait = Trait.NORMAL
var b_effect: Effect = Effect.NONE
var bounces: int = 0
var life_time: float = 2.0
var mass: float = 1.0
var grav_scale: float = 1.0

var velocity: Vector2
var time_alive: float = 0.0
var traveled_distance: float = 0.0
var base_damage: float = 0.0 

var bullet_gravity = 1200.0 
var beam_length: float = 0.0 

var is_stuck = false
var is_returning = false

@onready var raycast = $RayCast

func _ready():
	add_to_group("bullets")
	velocity = Vector2(speed, 0).rotated(rotation)
	base_damage = damage
	
	if b_trait == Trait.BEAM or b_trait == Trait.CHAIN_BEAM:
		scale.x = beam_length / 128.0
		position += Vector2(beam_length / 2.0, 0).rotated(rotation)
		get_tree().create_timer(life_time).timeout.connect(explode_or_die)
		
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if is_stuck: return 
	
	time_alive += delta
	
	if b_trait != Trait.BEAM and b_trait != Trait.CHAIN_BEAM:
		velocity.y += (bullet_gravity * grav_scale) * delta

	match b_trait:
		Trait.BOOMERANG:
			if time_alive > life_time:
				is_returning = true
			if is_returning and is_instance_valid(shooter):
				velocity = (shooter.global_position - global_position).normalized() * speed
		Trait.HOMING:
			var closest = get_closest_player()
			if closest:
				velocity = velocity.lerp((closest.global_position - global_position).normalized() * speed, 5.0 * delta)
		Trait.REMOTE:
			if is_instance_valid(shooter):
				velocity = velocity.lerp((shooter.sync_mouse_pos - global_position).normalized() * speed, 8.0 * delta)
	
	var step = velocity * delta
	traveled_distance += step.length()
	damage = max(1.0, base_damage * (1.0 - (traveled_distance / 4000.0)))
	
	if bounces > 0 and raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var collider = raycast.get_collider()
		if collider and not collider.has_method("rpc_take_damage"):
			velocity = velocity.bounce(normal)
			velocity *= 0.8 
			bounces -= 1
			position += normal * 2 
			if bounces <= 0 and b_effect == Effect.EXPLOSION:
				explode_or_die()
	
	position += velocity * delta
	rotation = velocity.angle()

func get_closest_player():
	var closest_dist = 1000.0
	var closest_player = null
	for p in get_tree().get_nodes_in_group("players"):
		if p != shooter and not p.is_dead:
			var d = global_position.distance_to(p.global_position)
			if d < closest_dist:
				closest_dist = d
				closest_player = p
	return closest_player

func _on_area_entered(area):
	if area.is_in_group("bullets") and area.shooter != shooter:
		if mass > area.mass: area.explode_or_die()
		elif mass < area.mass: explode_or_die()
		else:
			area.explode_or_die()
			explode_or_die()

func _on_body_entered(body):
	if body == shooter: 
		if is_returning and multiplayer.is_server():
			shooter.rpc("force_reload")
			queue_free()
		return 
	
	if body.has_method("rpc_take_damage"):
		if multiplayer.is_server():
			body.rpc_take_damage.rpc(damage)
			
			if b_effect == Effect.SLOW: body.rpc_apply_status.rpc("slow")
			elif b_effect == Effect.PIN: body.rpc_apply_status.rpc("pin")
			elif b_effect == Effect.PULL_ENEMY: body.rpc_pull.rpc(shooter.global_position, 800)
			
			if b_trait == Trait.HARPOON:
				body.rpc_pull.rpc(shooter.global_position, 2000) 
			
			if b_trait == Trait.CHAIN_BEAM:
				var next = get_closest_player()
				if next and next != body:
					next.rpc_take_damage.rpc(damage * 0.5)

	if b_trait == Trait.GRAPPLE:
		is_stuck = true
		velocity = Vector2.ZERO
		return 

	if b_trait != Trait.PIERCE and b_trait != Trait.BEAM and b_trait != Trait.CHAIN_BEAM:
		explode_or_die()

@rpc("any_peer", "call_local", "reliable")
func destroy_bullet():
	if multiplayer.is_server():
		if shooter and (b_trait == Trait.REMOTE or b_trait == Trait.GRAPPLE):
			shooter.rpc("force_reload")
		queue_free()

func explode_or_die():
	if b_effect == Effect.EXPLOSION and multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != shooter and global_position.distance_to(p.global_position) < 150:
				p.rpc_take_damage.rpc(damage * 1.5) 
				
	if b_trait == Trait.REMOTE and multiplayer.is_server() and shooter:
		shooter.rpc("force_reload")
		
	queue_free()
