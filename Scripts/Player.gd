extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_AMMO = 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
var ammo = MAX_AMMO
var hp = 100
var original_color: Color 
var original_scale: Vector2

var can_shoot: bool = true
var fire_rate: float = 0.25 
var spawn_position: Vector2
var is_dead: bool = false

var reload_time: float = 2.0
var reload_timer: Timer

var reload_delay: float = 1.0
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
	
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_finished)
	add_child(reload_timer)
	
	reload_delay_timer = Timer.new()
	reload_delay_timer.wait_time = reload_delay
	reload_delay_timer.one_shot = true
	reload_delay_timer.timeout.connect(_on_reload_delay_finished)
	add_child(reload_delay_timer)
	
	update_ammo_ui()
	reload_circle.hide()

func _physics_process(delta):
	if is_dead:
		return 

	hp_bar.value = hp
	
	if not reload_timer.is_stopped():
		reload_circle.show()
		var progress = (1.0 - (reload_timer.time_left / reload_timer.wait_time)) * 100
		reload_circle.value = progress
	else:
		reload_circle.hide()

	if not is_multiplayer_authority():
		return

	if is_dummy:
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animate_jump()

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	weapon_pivot.look_at(get_global_mouse_position())

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_just_pressed("ui_accept"):
		if ammo > 0 and can_shoot:
			shoot()

func shoot():
	can_shoot = false 
	
	rpc_shoot_action.rpc(muzzle.global_position, weapon_pivot.rotation)
	
	get_tree().create_timer(fire_rate).timeout.connect(func(): can_shoot = true)

@rpc("any_peer", "call_local", "reliable")
func rpc_shoot_action(pos, rot):
	ammo -= 1
	animate_recoil()
	update_ammo_ui()
	
	var bullet = bullet_scene.instantiate()
	bullet.shooter = self 
	get_tree().current_scene.add_child(bullet) 
	bullet.global_position = pos
	bullet.rotation = rot
	
	reload_timer.stop()
	reload_delay_timer.stop()
	
	if ammo <= 0:
		reload_timer.start()
	else:
		reload_delay_timer.start()

func _on_reload_delay_finished():
	reload_timer.start()

func _on_reload_finished():
	ammo = MAX_AMMO
	update_ammo_ui()

func update_ammo_ui():
	for i in range(ammo_ui.get_child_count()):
		var bullet_rect = ammo_ui.get_child(i)
		if i < ammo:
			bullet_rect.modulate.a = 1.0 
		else:
			bullet_rect.modulate.a = 0.2 

func animate_jump():
	var tween = create_tween()
	sprite.scale = Vector2(original_scale.x * 0.5, original_scale.y * 1.5)
	tween.tween_property(sprite, "scale", original_scale, 0.3).set_trans(Tween.TRANS_ELASTIC)

func animate_recoil():
	var tween = create_tween()
	gun.position.x = original_gun_pos.x - 15 
	tween.tween_property(gun, "position:x", original_gun_pos.x, 0.2).set_trans(Tween.TRANS_SPRING)

@rpc("any_peer", "call_local", "reliable")
func rpc_take_damage(amount):
	if is_dead: return 
	
	hp -= amount
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "modulate", original_color, 0.2) 
	
	if hp <= 0:
		die()

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
	ammo = MAX_AMMO
	is_dead = false
	collision_shape.set_deferred("disabled", false) 
	
	update_ammo_ui()
	hp_bar.show()
	ammo_ui.show()
	
	show()
