extends CharacterBody2D

enum GunType { 
	BUCKSHOT, SNIPER, AUTO_RIFLE, SMG, BURST_PISTOL, REVOLVER, 
	LIGHTNING_GUN, GRAPPLING_HOOK, FLAMETHROWER, CHARGE_GUN, 
	SORCERER_WAND, GRENADE_LAUNCHER, BOW, PLASMA_CANNON, SAWED_OFF, 
	NAILGUN, TDE_BEAM, TRACTOR_BEAM, DISC_LAUNCHER, ROCKET_LAUNCHER, 
	BOOMERANG, ENERGY_WHIP, MINIGUN, HARPOON, SLUSH_LAUNCHER
}

enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM }
enum Effect { NONE, EXPLOSION, SLOW, PIN, PULL_ENEMY, PULL_SELF }

const WEAPON_STATS = {
	GunType.BUCKSHOT: { "ammo": 2, "fr": 0.8, "dmg": 15, "spd": 1000, "spr": 0.25, "pel": 6, "scl": 0.5, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.4, "kb": 300, "burst": 1 },
	GunType.SNIPER: { "ammo": 1, "fr": 1.5, "dmg": 85, "spd": 4500, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.PIERCE, "eff": Effect.NONE, "bnce": 0, "life": 2.0, "kb": 400, "burst": 1 },
	GunType.AUTO_RIFLE: { "ammo": 25, "fr": 0.12, "dmg": 12, "spd": 1500, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": true, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 50, "burst": 1 },
	GunType.SMG: { "ammo": 40, "fr": 0.07, "dmg": 7, "spd": 1300, "spr": 0.15, "pel": 1, "scl": 0.6, "auto": true, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.0, "kb": 20, "burst": 1 },
	GunType.BURST_PISTOL: { "ammo": 15, "fr": 0.5, "dmg": 12, "spd": 1200, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 0, "burst": 3 },
	GunType.REVOLVER: { "ammo": 6, "fr": 0.4, "dmg": 25, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 100, "burst": 1 },
	
	GunType.LIGHTNING_GUN: { "ammo": 5, "fr": 0.6, "dmg": 30, "spd": 4000, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.8, "trait": Trait.BEAM, "eff": Effect.NONE, "bnce": 0, "life": 0.1, "kb": 0, "burst": 1 },
	GunType.GRAPPLING_HOOK: { "ammo": 1, "fr": 1.0, "dmg": 5, "spd": 2000, "spr": 0.0, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.PULL_SELF, "bnce": 0, "life": 0.6, "kb": 0, "burst": 1 },
	GunType.FLAMETHROWER: { "ammo": 60, "fr": 0.05, "dmg": 4, "spd": 600, "spr": 0.3, "pel": 2, "scl": 0.4, "auto": true, "rl": 3.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.3, "kb": 10, "burst": 1 },
	GunType.CHARGE_GUN: { "ammo": 3, "fr": 1.2, "dmg": 60, "spd": 2500, "spr": 0.0, "pel": 1, "scl": 1.8, "auto": false, "rl": 2.2, "trait": Trait.PIERCE, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 500, "burst": 1 },
	
	GunType.SORCERER_WAND: { "ammo": 5, "fr": 0.7, "dmg": 20, "spd": 600, "spr": 0.4, "pel": 1, "scl": 0.9, "auto": false, "rl": 2.0, "trait": Trait.HOMING, "eff": Effect.NONE, "bnce": 0, "life": 3.0, "kb": 0, "burst": 1 },
	GunType.GRENADE_LAUNCHER: { "ammo": 3, "fr": 0.9, "dmg": 10, "spd": 800, "spr": 0.1, "pel": 1, "scl": 1.2, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 2, "life": 2.0, "kb": 150, "burst": 1 },
	GunType.BOW: { "ammo": 1, "fr": 1.0, "dmg": 45, "spd": 1600, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 2.5, "kb": 0, "burst": 1 },
	GunType.PLASMA_CANNON: { "ammo": 4, "fr": 1.2, "dmg": 60, "spd": 400, "spr": 0.0, "pel": 1, "scl": 3.5, "auto": false, "rl": 2.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 4.0, "kb": 200, "burst": 1 },
	GunType.SAWED_OFF: { "ammo": 2, "fr": 0.5, "dmg": 25, "spd": 1100, "spr": 0.4, "pel": 10, "scl": 0.5, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.2, "kb": 1200, "burst": 1 },
	
	GunType.NAILGUN: { "ammo": 12, "fr": 0.3, "dmg": 10, "spd": 1400, "spr": 0.05, "pel": 1, "scl": 0.5, "auto": true, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.PIN, "bnce": 0, "life": 1.0, "kb": 0, "burst": 1 },
	GunType.TDE_BEAM: { "ammo": 40, "fr": 0.05, "dmg": 2, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.5, "auto": true, "rl": 2.5, "trait": Trait.BEAM, "eff": Effect.NONE, "bnce": 0, "life": 0.05, "kb": 0, "burst": 1 },
	GunType.TRACTOR_BEAM: { "ammo": 30, "fr": 0.1, "dmg": 3, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.6, "auto": true, "rl": 2.0, "trait": Trait.BEAM, "eff": Effect.PULL_ENEMY, "bnce": 0, "life": 0.1, "kb": 0, "burst": 1 },
	GunType.DISC_LAUNCHER: { "ammo": 5, "fr": 0.6, "dmg": 30, "spd": 900, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 3, "life": 3.0, "kb": 0, "burst": 1 },
	GunType.ROCKET_LAUNCHER: { "ammo": 1, "fr": 1.5, "dmg": 25, "spd": 700, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 0, "life": 3.0, "kb": 300, "burst": 1 },
	
	GunType.BOOMERANG: { "ammo": 1, "fr": 1.0, "dmg": 40, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.2, "auto": false, "rl": 1.5, "trait": Trait.BOOMERANG, "eff": Effect.NONE, "bnce": 0, "life": 3.0, "kb": 0, "burst": 1 },
	GunType.ENERGY_WHIP: { "ammo": 8, "fr": 0.4, "dmg": 35, "spd": 3000, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.5, "trait": Trait.PIERCE, "eff": Effect.NONE, "bnce": 0, "life": 0.15, "kb": 0, "burst": 1 },
	GunType.MINIGUN: { "ammo": 100, "fr": 0.06, "dmg": 6, "spd": 1600, "spr": 0.15, "pel": 1, "scl": 0.7, "auto": true, "rl": 4.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 80, "burst": 1 },
	GunType.HARPOON: { "ammo": 1, "fr": 1.2, "dmg": 40, "spd": 1800, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.PIERCE, "eff": Effect.PULL_SELF, "bnce": 0, "life": 1.0, "kb": 0, "burst": 1 },
	GunType.SLUSH_LAUNCHER: { "ammo": 10, "fr": 0.4, "dmg": 10, "spd": 900, "spr": 0.1, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.SLOW, "bnce": 0, "life": 1.5, "kb": 0, "burst": 1 }
}

@export var current_weapon: GunType = GunType.BUCKSHOT:
	set(value):
		current_weapon = value
		if is_node_ready(): 
			equip_weapon()

const BASE_SPEED = 400.0
const JUMP_VELOCITY = -600.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

var hp = 100
var original_color: Color 
var original_scale: Vector2

var ammo = 0
var max_ammo = 0
var can_shoot: bool = true
var spawn_position: Vector2
var is_dead: bool = false

var current_speed = BASE_SPEED
var status_slow_timer = 0.0
var status_pin_timer = 0.0

var reload_timer: Timer
var reload_delay_timer: Timer

@export var is_dummy: bool = false
@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var gun = $WeaponPivot
@onready var muzzle = $WeaponPivot/Muzzle
@onready var hp_bar = $Life
@onready var collision_shape = $CollisionShape2D
@onready var original_gun_pos = gun.position 
@onready var ammo_ui = $AmmoUI
@onready var reload_circle = $ReloadCircle

var bullet_scene = preload("res://Scenes/Bullet.tscn")

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	original_color = sprite.modulate
	original_scale = sprite.scale
	spawn_position = global_position 
	
	var my_peer_id = name.to_int()
	if GameManager.players.has(my_peer_id):
		current_weapon = GameManager.players[my_peer_id]["weapon"]
	else:
		equip_weapon() 
	
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_finished)
	add_child(reload_timer)
	reload_delay_timer = Timer.new() 
	reload_delay_timer.wait_time = 1.0
	reload_delay_timer.one_shot = true
	reload_delay_timer.timeout.connect(_on_reload_delay_finished)
	add_child(reload_delay_timer)
	
	reload_circle.hide()
	
	if is_multiplayer_authority() and has_node("Camera2D"):
		$Camera2D.make_current()

func equip_weapon():
	var stats = WEAPON_STATS[current_weapon] 
	max_ammo = stats.ammo
	ammo = max_ammo
	
	for child in ammo_ui.get_children(): 
		child.queue_free()
		
	for i in range(max_ammo):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(8, 8)
		rect.color = Color.YELLOW
		ammo_ui.add_child(rect)
		
	update_ammo_ui()

func _physics_process(delta):
	if is_dead: return 

	handle_status_effects(delta)

	hp_bar.value = hp
	if not reload_timer.is_stopped():
		reload_circle.show()
		reload_circle.value = (1.0 - (reload_timer.time_left / reload_timer.wait_time)) * 100
	else:
		reload_circle.hide()

	if not is_multiplayer_authority(): return

	if is_dummy:
		if not is_on_floor(): velocity.y += gravity * delta
		move_and_slide()
		return

	if not is_on_floor(): velocity.y += gravity * delta

	if status_pin_timer <= 0:
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animate_jump()

		var direction = Input.get_axis("ui_left", "ui_right")
		
		var speed_modifier = current_speed
		if current_weapon == GunType.MINIGUN and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			speed_modifier *= 0.4 
			
		if direction: velocity.x = direction * speed_modifier
		else: velocity.x = move_toward(velocity.x, 0, speed_modifier)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed * 0.1) 

	move_and_slide()
	weapon_pivot.look_at(get_global_mouse_position())

	var stats = WEAPON_STATS[current_weapon]
	var wants_to_shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) if stats.auto else Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if wants_to_shoot and ammo > 0 and can_shoot:
		shoot()

func handle_status_effects(delta):
	if status_pin_timer > 0:
		status_pin_timer -= delta
		sprite.modulate = Color.WEB_GRAY 
	elif status_slow_timer > 0:
		status_slow_timer -= delta
		current_speed = BASE_SPEED * 0.4
		sprite.modulate = Color.CYAN 
	else:
		current_speed = BASE_SPEED
		sprite.modulate = original_color

func shoot():
	can_shoot = false 
	var stats = WEAPON_STATS[current_weapon]
	
	for b in range(stats.burst):
		if ammo <= 0 or is_dead: break
		rpc_shoot_action.rpc(muzzle.global_position, weapon_pivot.rotation, current_weapon)
		if stats.burst > 1:
			await get_tree().create_timer(0.08).timeout
			
	get_tree().create_timer(stats.fr).timeout.connect(func(): can_shoot = true)

@rpc("any_peer", "call_local", "reliable")
func rpc_shoot_action(pos, rot, weapon_id):
	var stats = WEAPON_STATS[weapon_id]
	ammo -= 1
	animate_recoil()
	update_ammo_ui()
	
	if stats.kb > 0 and is_multiplayer_authority():
		var push_dir = Vector2.RIGHT.rotated(rot + PI) 
		velocity += push_dir * stats.kb
	
	for i in range(stats.pel):
		var bullet = bullet_scene.instantiate()
		bullet.shooter = self 
		
		bullet.global_position = pos
		var random_spread = randf_range(-stats.spr, stats.spr)
		bullet.rotation = rot + random_spread
		
		bullet.speed = stats.spd
		bullet.damage = stats.dmg
		bullet.scale = Vector2(stats.scl, stats.scl)
		bullet.b_trait = stats.trait
		bullet.b_effect = stats.eff
		bullet.bounces = stats.bnce
		bullet.life_time = stats.life
		
		if stats.trait == Trait.BEAM:
			bullet.scale.x = 20.0 
			bullet.modulate.a = 0.5
			
		get_tree().current_scene.add_child(bullet) 
	
	reload_timer.stop()
	reload_delay_timer.stop()
	reload_timer.wait_time = stats.rl
	
	if ammo <= 0: reload_timer.start()
	else: reload_delay_timer.start()

@rpc("any_peer", "call_local", "reliable")
func rpc_apply_status(type):
	if type == "slow": status_slow_timer = 2.0
	elif type == "pin": status_pin_timer = 1.5

@rpc("any_peer", "call_local", "reliable")
func rpc_pull(target_pos, force):
	if not is_multiplayer_authority(): return
	var dir = (target_pos - global_position).normalized()
	velocity += dir * force 

@rpc("any_peer", "call_local", "reliable")
func rpc_take_damage(amount):
	if is_dead: return 
	hp -= amount
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "modulate", original_color, 0.2) 
	if hp <= 0: die()

func _on_reload_delay_finished(): reload_timer.start()
func _on_reload_finished():
	ammo = max_ammo
	update_ammo_ui()

func update_ammo_ui():
	for i in range(ammo_ui.get_child_count()):
		var bullet_rect = ammo_ui.get_child(i)
		bullet_rect.modulate.a = 1.0 if i < ammo else 0.2 

func animate_jump():
	var tween = create_tween()
	sprite.scale = Vector2(original_scale.x * 0.5, original_scale.y * 1.5)
	tween.tween_property(sprite, "scale", original_scale, 0.3).set_trans(Tween.TRANS_ELASTIC)

func animate_recoil():
	var tween = create_tween()
	gun.position.x = original_gun_pos.x - 15 
	tween.tween_property(gun, "position:x", original_gun_pos.x, 0.2).set_trans(Tween.TRANS_SPRING)

func die():
	is_dead = true
	hide() 
	hp_bar.hide()
	ammo_ui.hide()
	collision_shape.set_deferred("disabled", true) 
	get_tree().create_timer(3.0).timeout.connect(respawn)

func respawn():
	global_position = spawn_position 
	hp = 100
	ammo = max_ammo
	is_dead = false
	status_pin_timer = 0
	status_slow_timer = 0
	collision_shape.set_deferred("disabled", false) 
	update_ammo_ui()
	hp_bar.show()
	ammo_ui.show()
	show()
