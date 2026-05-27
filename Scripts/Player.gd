extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_AMMO = 3

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
var ammo = MAX_AMMO
var hp = 100
var original_color: Color 
var can_shoot: bool = true
var fire_rate: float = 0.25 
var spawn_position: Vector2
var is_dead: bool = false

@export var is_dummy: bool = false

@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var gun = $WeaponPivot
@onready var muzzle = $WeaponPivot/Muzzle
@onready var hp_bar = $Life
@onready var collision_shape = $CollisionShape2D
@onready var original_gun_pos = gun.position 

var bullet_scene = preload("res://Scenes/Bullet.tscn")

func _ready():
	original_color = sprite.modulate
	spawn_position = global_position 

func _physics_process(delta):
	if is_dead:
		return 

	hp_bar.value = hp
	
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
	ammo -= 1
	can_shoot = false 
	animate_recoil()
	
	var bullet = bullet_scene.instantiate()
	bullet.shooter = self 
	get_parent().add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.rotation = weapon_pivot.rotation
	
	get_tree().create_timer(1.0).timeout.connect(func(): ammo = min(ammo + 1, MAX_AMMO))
	
	get_tree().create_timer(fire_rate).timeout.connect(func(): can_shoot = true)

func animate_jump():
	var tween = create_tween()
	sprite.scale = Vector2(0.5, 1.5)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_ELASTIC)

func animate_recoil():
	var tween = create_tween()
	gun.position.x = original_gun_pos.x - 15 
	tween.tween_property(gun, "position:x", original_gun_pos.x, 0.2).set_trans(Tween.TRANS_SPRING)

func take_damage(amount):
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
	collision_shape.set_deferred("disabled", true) 
	
	get_tree().create_timer(3.0).timeout.connect(respawn)

func respawn():
	global_position = spawn_position 
	hp = 100
	ammo = MAX_AMMO
	is_dead = false
	collision_shape.set_deferred("disabled", false) 
	show()
	hp_bar.show()
