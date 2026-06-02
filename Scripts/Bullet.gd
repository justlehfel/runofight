extends Area2D

enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM, CHAIN_BULLET, GRAPPLE, REMOTE, HARPOON, FLAME, SWAP, STASIS, FISHING }
enum Effect { NONE, EXPLOSION, SLOW, NAIL_STUN, PULL_ENEMY, PULL_SELF }

var speed = 1000.0
var damage = 25.0
var shooter = null 

var b_trait: Trait = Trait.NORMAL
var b_effect: Effect = Effect.NONE
var bounces: int = 0
var life_time: float = 10.0
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

var base_scale: Vector2 = Vector2.ONE
var trail_points = []
var trail_max_length = 5
var spin_angle = 0.0

@onready var raycast = $RayCast
@onready var sprite = $Sprite2D

func _ready():
	add_to_group("bullets")
	velocity = Vector2(speed, 0).rotated(rotation)
	base_damage = damage
	base_scale = scale
	
	if is_instance_valid(shooter): raycast.add_exception(shooter) 

	if b_trait == Trait.BEAM:
		sprite.offset = Vector2(64, 0) 
		base_scale.x = beam_length / 128.0 
		scale = base_scale
		
	if life_time > 0: get_tree().create_timer(life_time).timeout.connect(explode_or_die)
		
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if is_stuck: return 
	
	time_alive += delta
	if b_trait != Trait.BEAM and b_trait != Trait.FLAME: velocity.y += (bullet_gravity * grav_scale) * delta

	match b_trait:
		Trait.BOOMERANG:
			if time_alive > life_time and not is_returning: is_returning = true
			if is_returning and is_instance_valid(shooter):
				var dir = (shooter.global_position - global_position).normalized()
				var ortho = Vector2(-dir.y, dir.x)
				velocity = velocity.lerp(dir * speed + ortho * 200.0, 5.0 * delta)
		Trait.HOMING:
			var closest = get_closest_player(null)
			if closest: velocity = velocity.lerp((closest.global_position - global_position).normalized() * speed, 5.0 * delta)
		Trait.REMOTE:
			if is_instance_valid(shooter):
				velocity = velocity.lerp((shooter.sync_mouse_pos - global_position).normalized() * speed, 12.0 * delta)
	
	var step = velocity * delta
	traveled_distance += step.length()
	
	var falloff_dist = 4000.0
	if mass == 2.0 and bounces == 0: falloff_dist = 1500.0 
	if mass == 3.0 and speed == 1100: falloff_dist = 800.0 
	if b_trait == Trait.FLAME or b_trait == Trait.REMOTE or mass == 6.0 or mass == 7.0: falloff_dist = 999999.0 
	
	damage = max(1.0, base_damage * (1.0 - (traveled_distance / falloff_dist)))
	
	raycast.target_position = Vector2(step.length() + 5.0, 0)
	if bounces > 0 and raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var collider = raycast.get_collider()
		if collider and not collider.has_method("rpc_take_damage"):
			velocity = velocity.bounce(normal)
			velocity *= 0.8 
			bounces -= 1
			position += normal * 2 
			if bounces <= 0 and b_effect == Effect.EXPLOSION: explode_or_die() 
	
	position += velocity * delta
	
	if b_trait != Trait.BEAM:
		rotation = velocity.angle()
		
	trail_points.insert(0, global_position)
	if trail_points.size() > trail_max_length: trail_points.pop_back()
	queue_redraw() 

	if b_trait != Trait.BEAM and b_trait != Trait.BOOMERANG and mass != 7.0:
		var speed_factor = velocity.length() * 0.0003
		var stretch_x = 1.0 + speed_factor
		var stretch_y = max(0.2, 1.0 - speed_factor * 0.5) 
		scale = Vector2(base_scale.x * stretch_x, base_scale.y * stretch_y)

	if b_trait == Trait.BOOMERANG or mass == 7.0:
		spin_angle += 25.0 * delta
		sprite.rotation = spin_angle

	if b_trait == Trait.FLAME:
		scale = base_scale * randf_range(0.8, 1.3)
		sprite.modulate = Color(1.0, randf_range(0.2, 0.6), 0.0, randf_range(0.6, 1.0))
	elif b_trait == Trait.BEAM:
		sprite.modulate.a = 0.5 + sin(time_alive * 30.0) * 0.5

func _draw():
	if trail_points.size() > 1 and b_trait != Trait.BEAM and b_trait != Trait.FLAME:
		var trail_color = Color(1.0, 1.0, 1.0, 0.3) 
		
		if b_effect == Effect.EXPLOSION: trail_color = Color(1.0, 0.4, 0.0, 0.5)
		elif b_effect == Effect.SLOW or b_trait == Trait.STASIS: trail_color = Color(0.0, 0.8, 1.0, 0.5)
		elif b_effect == Effect.NAIL_STUN: trail_color = Color(0.6, 0.6, 0.6, 0.5)
		elif b_trait == Trait.SWAP: trail_color = Color(0.8, 0.2, 1.0, 0.5)

		for i in range(trail_points.size() - 1):
			var p1 = to_local(trail_points[i])
			var p2 = to_local(trail_points[i+1])
			var alpha = 1.0 - (float(i) / trail_points.size())
			var current_color = Color(trail_color.r, trail_color.g, trail_color.b, trail_color.a * alpha)
			draw_line(p1, p2, current_color, 4.0 * alpha)

	if b_effect == Effect.EXPLOSION: 
		draw_circle(Vector2.ZERO, 15, Color(1.0, 0.2, 0.0, 0.2 + sin(time_alive*15)*0.1))
	elif b_trait == Trait.STASIS: 
		draw_circle(Vector2.ZERO, 15, Color(0.0, 0.5, 1.0, 0.3))
	elif b_trait == Trait.HOMING: 
		draw_circle(Vector2.ZERO, 10, Color(1.0, 0.0, 1.0, 0.3))

func get_closest_player(ignore_player):
	var closest_dist = 800.0 
	var closest_player = null
	for p in get_tree().get_nodes_in_group("players"):
		if p != ignore_player and not p.is_dead and global_position.distance_to(p.global_position) < closest_dist:
			closest_dist = global_position.distance_to(p.global_position); closest_player = p
	return closest_player

func _on_area_entered(area):
	if area.is_in_group("bullets") and area.shooter != shooter:
		if mass > area.mass: area.explode_or_die()
		elif mass < area.mass: explode_or_die()
		else: area.explode_or_die(); explode_or_die()

func _on_body_entered(body):
	if body == shooter: 
		if b_trait == Trait.BOOMERANG and is_returning and multiplayer.is_server(): shooter.rpc("force_reload", true); queue_free()
		return 
	
	if body.has_method("rpc_take_damage"):
		if multiplayer.is_server():
			var shooter_id = shooter.name.to_int() if shooter else -1
			
			if body.get("is_reflecting"):
				velocity = -velocity; shooter = body; b_trait = Trait.NORMAL; trail_points.clear(); return
			
			if b_trait != Trait.CHAIN_BULLET: body.rpc_take_damage.rpc(damage, shooter_id)
			if shooter and shooter.get("current_body") == 15: body.rpc_apply_status.rpc("poison") 
			
			if b_effect == Effect.SLOW: body.rpc_apply_status.rpc("slow")
			elif b_effect == Effect.NAIL_STUN: body.rpc_apply_status.rpc("nail", velocity.normalized())
			elif b_effect == Effect.PULL_ENEMY: body.rpc_pull.rpc(shooter.global_position, 300); body.rpc_apply_status.rpc("tractor")
			
			if b_trait == Trait.HARPOON: body.rpc_pull.rpc(shooter.global_position, 2500) 
			if b_trait == Trait.FISHING: body.rpc_pull.rpc(shooter.global_position, 1500) 
			if b_trait == Trait.STASIS: body.rpc_apply_status.rpc("stasis", Vector2.ZERO, 3.0, shooter_id)
			
			if b_trait == Trait.SWAP and shooter:
				var temp = shooter.global_position; shooter.global_position = body.global_position; body.global_position = temp
			
			if b_trait == Trait.CHAIN_BULLET:
				body.rpc_take_damage.rpc(damage, shooter_id)
				var next = get_closest_player(body)
				if next: velocity = (next.global_position - global_position).normalized() * speed
				else: explode_or_die()

		if b_trait == Trait.BOOMERANG: is_returning = true; return
		if b_trait == Trait.GRAPPLE:
			if multiplayer.is_server() and shooter: shooter.rpc("trigger_grapple_cooldown")
			explode_or_die()
			return

		if b_trait != Trait.PIERCE and b_trait != Trait.BEAM and b_trait != Trait.CHAIN_BULLET: explode_or_die()
	else:
		if multiplayer.is_server() and body.has_meta("hp"):
			var w_hp = body.get_meta("hp") - damage
			if w_hp <= 0: body.queue_free()
			else: body.set_meta("hp", w_hp)
			
		if b_trait == Trait.SWAP and shooter and multiplayer.is_server(): shooter.global_position = global_position 
		if b_trait == Trait.GRAPPLE:
			is_stuck = true; velocity = Vector2.ZERO
			if multiplayer.is_server(): rpc("stick_grapple", global_position)
			return
		if bounces <= 0 and b_trait != Trait.PIERCE and b_trait != Trait.BEAM: explode_or_die()

@rpc("call_local", "reliable")
func stick_grapple(pos): is_stuck = true; global_position = pos; velocity = Vector2.ZERO

@rpc("any_peer", "call_local", "reliable")
func destroy_bullet():
	if multiplayer.is_server():
		if shooter and (b_trait == Trait.REMOTE): shooter.rpc("force_reload", true)
		queue_free()

func explode_or_die():
	if multiplayer.is_server():
		if b_effect == Effect.EXPLOSION:
			var shooter_id = shooter.name.to_int() if shooter else -1
			if shooter: shooter.rpc_spawn_object.rpc("explosion", global_position)
			for p in get_tree().get_nodes_in_group("players"):
				if p != shooter and global_position.distance_to(p.global_position) < 150: p.rpc_take_damage.rpc(damage * 1.5, shooter_id, true) 
				if p == shooter and p.current_body != 17 and global_position.distance_to(p.global_position) < 150: p.rpc_take_damage.rpc(damage * 1.5, shooter_id, true) 
					
		if b_trait == Trait.REMOTE and shooter: shooter.rpc("force_reload", true)
		if b_trait == Trait.GRAPPLE and shooter and not is_stuck: shooter.rpc("trigger_grapple_cooldown")
		if b_trait == Trait.BOOMERANG and shooter and not is_returning: shooter.rpc("force_reload", false) 
			
	queue_free()
