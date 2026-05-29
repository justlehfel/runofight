extends Area2D

enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM }
enum Effect { NONE, EXPLOSION, SLOW, PIN, PULL_ENEMY, PULL_SELF }

var speed = 1000.0
var damage = 25
var shooter = null 

var b_trait: Trait = Trait.NORMAL
var b_effect: Effect = Effect.NONE
var bounces: int = 0
var life_time: float = 2.0

var velocity: Vector2
var time_alive: float = 0.0

var bullet_gravity = 1200.0 

@onready var raycast = $RayCast

func _ready():
	velocity = Vector2(speed, 0).rotated(rotation)
	get_tree().create_timer(life_time).timeout.connect(explode_or_die)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	time_alive += delta
	if b_trait != Trait.BEAM:
		velocity.y += bullet_gravity * delta

	match b_trait:
		Trait.BOOMERANG:
			velocity -= velocity.normalized() * (speed * 2.5) * delta 
		Trait.HOMING:
			var closest_dist = 1000.0
			var closest_player = null
			for p in get_tree().get_nodes_in_group("players"):
				if p != shooter and not p.is_dead:
					var d = global_position.distance_to(p.global_position)
					if d < closest_dist:
						closest_dist = d
						closest_player = p
			if closest_player:
				var dir = (closest_player.global_position - global_position).normalized()
				velocity = velocity.lerp(dir * speed, 5.0 * delta)
	
	if bounces > 0 and raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var collider = raycast.get_collider()
		if collider and not collider.has_method("rpc_take_damage"):
			velocity = velocity.bounce(normal)
			velocity *= 0.8 
			bounces -= 1
			position += normal * 2 
	
	position += velocity * delta
	rotation = velocity.angle()

func _on_body_entered(body):
	if body == shooter: return 
	
	if body.has_method("rpc_take_damage"):
		if multiplayer.is_server():
			body.rpc_take_damage.rpc(damage)
			if b_effect == Effect.SLOW: body.rpc_apply_status.rpc("slow")
			elif b_effect == Effect.PIN: body.rpc_apply_status.rpc("pin")
			elif b_effect == Effect.PULL_ENEMY: body.rpc_pull.rpc(shooter.global_position, 600)
		
	if b_effect == Effect.PULL_SELF and shooter and multiplayer.is_server():
		shooter.rpc_pull.rpc(global_position, 1200)

	if b_trait != Trait.PIERCE and b_trait != Trait.BEAM:
		explode_or_die()

func explode_or_die():
	if b_effect == Effect.EXPLOSION and multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != shooter and global_position.distance_to(p.global_position) < 150:
				p.rpc_take_damage.rpc(damage * 1.5) 
	queue_free()
