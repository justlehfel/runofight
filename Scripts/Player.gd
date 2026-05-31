extends CharacterBody2D

enum GunType { BUCKSHOT, SNIPER, AUTO_RIFLE, SMG, BURST_PISTOL, REVOLVER, LIGHTNING_GUN, GRAPPLING_HOOK, FLAMETHROWER, CHARGE_GUN, SORCERER_WAND, GRENADE_LAUNCHER, BOW, PLASMA_CANNON, SAWED_OFF, NAILGUN, TDE_BEAM, TRACTOR_BEAM, DISC_LAUNCHER, ROCKET_LAUNCHER, BOOMERANG, ENERGY_WHIP, MINIGUN, HARPOON, SLUSH_LAUNCHER }
enum BodyType { DEFAULT, PASSIVE_REGEN, GIANT, THORNS, DOUBLE_JUMP, FEATHER_WEIGHT, HEAVY_WEIGHT, AERODYNAMIC, FROZEN_FEET, ACID_BLOOD, REACTIVE_ARMOR, MICROBE, INVINCIBLE, VAMPIRE_BODY, FIRE_AURA, POISON_TOUCH, LIFESTEAL_AURA, BOMBER, LAST_STAND, FEATHER_FALLING, SCUM, STEALTH, GAMBLER, CHANNELER, ARACHNID, TURTLE, UNSTABLE }

enum AbilityType { DASH, SHIELD, REFLECT, SHRINK, HEAL, WALL_DESTRUCT, TELEPORT, SMASH, SWAP, SMOKE, ICE_WALL, MINES, SHOCKWAVE, ROLL, JETPACK, RAWWR, INVISIBILITY, FISHING_ROD, PROTECT_DOME, SOLID_DOME, STASIS, ANCHOR, BLINK, OVERCHARGE, DECOY }

enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM, CHAIN_BULLET, GRAPPLE, REMOTE, HARPOON, FLAME, SWAP, STASIS, FISHING }
enum Effect { NONE, EXPLOSION, SLOW, NAIL_STUN, PULL_ENEMY, PULL_SELF }

const WEAPON_STATS = {
	GunType.BUCKSHOT: { "ammo": 2, "fr": 0.8, "dmg": 7.5, "spd": 1800, "spr": 0.25, "pel": 6, "scl": 0.5, "auto": false, "rl": 2.2, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.4, "kb": 500, "burst": 1, "mass": 2.0, "grav": 0.0, "rl_type": 1 },
	GunType.SNIPER: { "ammo": 1, "fr": 1.5, "dmg": 42.5, "spd": 2000, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 2.0, "kb": 400, "burst": 1, "mass": 10.0, "grav": 1.0, "rl_type": 0 },
	GunType.AUTO_RIFLE: { "ammo": 25, "fr": 0.24, "dmg": 6.0, "spd": 1500, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": true, "rl": 4.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 50, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.SMG: { "ammo": 40, "fr": 0.07, "dmg": 3.5, "spd": 1300, "spr": 0.15, "pel": 1, "scl": 0.6, "auto": true, "rl": 3.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.0, "kb": 20, "burst": 1, "mass": 1.5, "grav": 1.0, "rl_type": 0 },
	GunType.BURST_PISTOL: { "ammo": 12, "fr": 0.5, "dmg": 9.0, "spd": 1200, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 0, "burst": 3, "mass": 2.5, "grav": 1.0, "rl_type": 0 },
	GunType.REVOLVER: { "ammo": 6, "fr": 0.8, "dmg": 23.75, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 2.75, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 100, "burst": 1, "mass": 4.0, "grav": 1.0, "rl_type": 0 },
	GunType.LIGHTNING_GUN: { "ammo": 5, "fr": 1.0, "dmg": 7.5, "spd": 3500, "spr": 0.0, "pel": 1, "scl": 0.8, "auto": false, "rl": 3.0, "trait": Trait.CHAIN_BULLET, "eff": Effect.NONE, "bnce": 0, "life": 0.5, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.GRAPPLING_HOOK: { "ammo": 1, "fr": 1.0, "dmg": 6.6, "spd": 3500, "spr": 0.0, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.GRAPPLE, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 0, "burst": 1, "mass": 5.0, "grav": 1.0, "rl_type": 2 },
	GunType.FLAMETHROWER: { "ammo": 60, "fr": 0.05, "dmg": 1.1, "spd": 400, "spr": 0.3, "pel": 2, "scl": 1.5, "auto": true, "rl": 3.0, "trait": Trait.FLAME, "eff": Effect.NONE, "bnce": 0, "life": 0.4, "kb": 10, "burst": 1, "mass": 0.5, "grav": 0.0, "rl_type": 0 },
	GunType.CHARGE_GUN: { "ammo": 1, "fr": 0.1, "dmg": 1.0, "spd": 2500, "spr": 0.0, "pel": 1, "scl": 0.2, "auto": false, "rl": 0.1, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 50, "burst": 1, "mass": 8.0, "grav": 1.0, "rl_type": 0 },
	GunType.SORCERER_WAND: { "ammo": 1, "fr": 0.5, "dmg": 26.45, "spd": 600, "spr": 0.0, "pel": 1, "scl": 0.9, "auto": false, "rl": 0.0, "trait": Trait.REMOTE, "eff": Effect.NONE, "bnce": 0, "life": 5.0, "kb": 0, "burst": 1, "mass": 2.0, "grav": 1.0, "rl_type": 2 },
	GunType.GRENADE_LAUNCHER: { "ammo": 3, "fr": 0.9, "dmg": 10.0, "spd": 800, "spr": 0.1, "pel": 1, "scl": 1.2, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 1, "life": 2.0, "kb": 150, "burst": 1, "mass": 6.0, "grav": 1.0, "rl_type": 0 },
	GunType.BOW: { "ammo": 1, "fr": 1.0, "dmg": 45.0, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 2.5, "kb": 0, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.PLASMA_CANNON: { "ammo": 3, "fr": 1.2, "dmg": 60.0, "spd": 400, "spr": 0.0, "pel": 1, "scl": 3.5, "auto": false, "rl": 2.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 4.0, "kb": 200, "burst": 1, "mass": 20.0, "grav": 0.0, "rl_type": 0 },
	GunType.SAWED_OFF: { "ammo": 2, "fr": 0.16, "dmg": 6.25, "spd": 1100, "spr": 0.4, "pel": 10, "scl": 0.5, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.15, "kb": 600, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.NAILGUN: { "ammo": 1, "fr": 0.3, "dmg": 25.6, "spd": 1800, "spr": 0.0, "pel": 1, "scl": 0.5, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NAIL_STUN, "bnce": 0, "life": 1.0, "kb": 0, "burst": 1, "mass": 2.0, "grav": 1.0, "rl_type": 0 },
	GunType.TDE_BEAM: { "ammo": 40, "fr": 0.05, "dmg": 0.1, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.5, "auto": true, "rl": 2.5, "trait": Trait.BEAM, "eff": Effect.NONE, "bnce": 0, "life": 0.05, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.TRACTOR_BEAM: { "ammo": 30, "fr": 0.1, "dmg": 1.5, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.6, "auto": true, "rl": 2.0, "trait": Trait.BEAM, "eff": Effect.PULL_ENEMY, "bnce": 0, "life": 0.1, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.DISC_LAUNCHER: { "ammo": 5, "fr": 0.6, "dmg": 15.0, "spd": 900, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 3, "life": 3.0, "kb": 0, "burst": 1, "mass": 7.0, "grav": 1.0, "rl_type": 0 },
	GunType.ROCKET_LAUNCHER: { "ammo": 1, "fr": 1.5, "dmg": 16.25, "spd": 700, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 0, "life": 3.0, "kb": 300, "burst": 1, "mass": 15.0, "grav": 0.0, "rl_type": 0 },
	GunType.BOOMERANG: { "ammo": 1, "fr": 1.0, "dmg": 20.0, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.2, "auto": false, "rl": 0.0, "trait": Trait.BOOMERANG, "eff": Effect.NONE, "bnce": 0, "life": 1.2, "kb": 0, "burst": 1, "mass": 6.0, "grav": 1.0, "rl_type": 2 },
	GunType.ENERGY_WHIP: { "ammo": 8, "fr": 0.2, "dmg": 8.75, "spd": 3000, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.5, "trait": Trait.PIERCE, "eff": Effect.NONE, "bnce": 0, "life": 0.08, "kb": 0, "burst": 1, "mass": 1.0, "grav": 1.0, "rl_type": 0 },
	GunType.MINIGUN: { "ammo": 100, "fr": 0.15, "dmg": 2.7, "spd": 1600, "spr": 0.25, "pel": 1, "scl": 0.7, "auto": true, "rl": 4.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 80, "burst": 1, "mass": 1.2, "grav": 1.0, "rl_type": 0 },
	GunType.HARPOON: { "ammo": 1, "fr": 1.2, "dmg": 20.0, "spd": 1800, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.HARPOON, "eff": Effect.NONE, "bnce": 0, "life": 1.0, "kb": 0, "burst": 1, "mass": 8.0, "grav": 1.0, "rl_type": 0 },
	GunType.SLUSH_LAUNCHER: { "ammo": 10, "fr": 0.4, "dmg": 9.0, "spd": 900, "spr": 0.1, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.SLOW, "bnce": 0, "life": 1.5, "kb": 0, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 }
}

const BODY_STATS = {
	BodyType.DEFAULT: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.PASSIVE_REGEN: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.GIANT: { "hp": 150, "spd": 0.8, "jmp": 0.9, "grv": 1.2, "scl": 1.6, "jumps": 1 },
	BodyType.THORNS: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.DOUBLE_JUMP: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 2 },
	BodyType.FEATHER_WEIGHT: { "hp": 80, "spd": 1.1, "jmp": 1.3, "grv": 0.6, "scl": 1.0, "jumps": 1 },
	BodyType.HEAVY_WEIGHT: { "hp": 130, "spd": 0.85, "jmp": 0.75, "grv": 1.8, "scl": 1.0, "jumps": 1 },
	BodyType.AERODYNAMIC: { "hp": 100, "spd": 1.35, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.FROZEN_FEET: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.ACID_BLOOD: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.REACTIVE_ARMOR: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.MICROBE: { "hp": 70, "spd": 1.2, "jmp": 1.1, "grv": 0.8, "scl": 0.5, "jumps": 1 },
	BodyType.INVINCIBLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.VAMPIRE_BODY: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.FIRE_AURA: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.POISON_TOUCH: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.LIFESTEAL_AURA: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.BOMBER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.LAST_STAND: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.FEATHER_FALLING: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.SCUM: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.STEALTH: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.GAMBLER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.CHANNELER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.ARACHNID: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.TURTLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 },
	BodyType.UNSTABLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "jumps": 1 }
}

const ABILITY_CD = {
	AbilityType.DASH: 4.0, AbilityType.SHIELD: 12.0, AbilityType.REFLECT: 15.0, AbilityType.SHRINK: 12.0, AbilityType.HEAL: 15.0,
	AbilityType.WALL_DESTRUCT: 8.0, AbilityType.TELEPORT: 8.0, AbilityType.SMASH: 10.0, AbilityType.SWAP: 12.0, AbilityType.SMOKE: 10.0,
	AbilityType.ICE_WALL: 10.0, AbilityType.MINES: 8.0, AbilityType.SHOCKWAVE: 8.0, AbilityType.ROLL: 5.0, AbilityType.JETPACK: 10.0,
	AbilityType.RAWWR: 15.0, AbilityType.INVISIBILITY: 12.0, AbilityType.FISHING_ROD: 10.0, AbilityType.PROTECT_DOME: 15.0, AbilityType.SOLID_DOME: 18.0,
	AbilityType.STASIS: 12.0, AbilityType.ANCHOR: 10.0, AbilityType.BLINK: 6.0, AbilityType.OVERCHARGE: 5.0, AbilityType.DECOY: 10.0
}

@export var current_weapon: GunType = GunType.BUCKSHOT
@export var current_body: BodyType = BodyType.DEFAULT
@export var current_ability: AbilityType = AbilityType.DASH

const BASE_SPEED = 400.0
const JUMP_VELOCITY = -600.0
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

var max_hp = 100.0
var hp = 100.0
var temp_hp = 0.0 
var original_color: Color 
var base_sprite_scale: Vector2 
var original_scale: Vector2

var ammo = 0
var max_ammo = 0
var can_shoot: bool = true
var spawn_position: Vector2
var is_dead: bool = false
var jumps_left = 1

var current_speed = BASE_SPEED
var status_slow_timer = 0.0
var status_pin_timer = 0.0
var status_blind_timer = 0.0
var status_stasis_timer = 0.0
var stasis_caster = -1
var nail_knockback_velocity = Vector2.ZERO

var reload_timer: Timer
var reload_delay_timer: Timer
var ability_timer = 0.0

var charge_level: float = 0.0
var is_charging: bool = false
var minigun_heat: float = 0.0
var tde_heat: float = 0.0
var active_grapple = null
var sync_mouse_pos: Vector2 = Vector2.ZERO

var time_since_spawn = 0.0
var regen_timer = 0.0
var channeler_timer = 0.0
var reactive_triggered = false
var was_on_floor = false

var is_reflecting = false
var reflect_timer = 0.0
var is_anchored = false
var anchor_timer = 0.0
var rawwr_timer = 0.0
var shrink_timer = 0.0
var roll_timer = 0.0
var jetpack_timer = 0.0
var smash_active = false
var invis_timer = 0.0

@export var is_dummy: bool = false
@onready var sprite = $Sprite2D
@onready var weapon_pivot = $WeaponPivot
@onready var gun_sprite = $WeaponPivot
@onready var muzzle = $WeaponPivot/Muzzle
@onready var hp_bar = $Life
@onready var collision_shape = $CollisionShape2D
@onready var original_gun_pos = gun_sprite.position 
@onready var ammo_ui = $AmmoUI
@onready var reload_circle = $ReloadCircle

var bullet_scene = preload("res://Scenes/Bullet.tscn")

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	add_to_group("players")
	original_color = sprite.modulate
	base_sprite_scale = sprite.scale 
	spawn_position = global_position
	
	var my_peer_id = name.to_int()
	if GameManager.players.has(my_peer_id):
		current_weapon = GameManager.players[my_peer_id]["weapon"]
		current_body = GameManager.players[my_peer_id]["body"]
		current_ability = GameManager.players[my_peer_id]["ability"]
		
	equip_runes() 
	
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

func equip_runes():
	var g_stats = WEAPON_STATS[current_weapon] 
	var b_stats = BODY_STATS[current_body]
	
	max_hp = b_stats.hp
	hp = max_hp
	hp_bar.max_value = max_hp
	
	original_scale = base_sprite_scale * b_stats.scl
	sprite.scale = original_scale
	
	max_ammo = g_stats.ammo
	charge_level = 0.0
	is_charging = false
	active_grapple = null
	minigun_heat = 0.0
	ability_timer = 0.0
	
	for child in ammo_ui.get_children(): 
		ammo_ui.remove_child(child)
		child.queue_free()
		
	for i in range(max_ammo):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(8, 8)
		rect.color = Color.YELLOW
		ammo_ui.add_child(rect)
		
	ammo = max_ammo
	update_ammo_ui()

func _physics_process(delta):
	if multiplayer.multiplayer_peer == null: return 
	time_since_spawn += delta
	if is_dead: return 

	if ability_timer > 0: ability_timer -= delta
	handle_status_effects(delta)
	process_body_passives(delta)
	process_abilities(delta)

	hp_bar.value = hp
	if not reload_timer.is_stopped():
		reload_circle.show()
		reload_circle.value = (1.0 - (reload_timer.time_left / reload_timer.wait_time)) * 100
	else:
		reload_circle.hide()

	if not is_multiplayer_authority(): return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_physical_key_pressed(KEY_E):
		if ability_timer <= 0 and status_stasis_timer <= 0:
			trigger_ability()

	var current_mouse = get_global_mouse_position()
	if current_mouse.distance_to(sync_mouse_pos) > 5.0:
		sync_mouse_pos = current_mouse
		rpc_update_mouse.rpc(sync_mouse_pos)

	var is_grappling = false
	if current_weapon == GunType.GRAPPLING_HOOK and is_instance_valid(active_grapple):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if active_grapple.is_stuck:
				var dir = (active_grapple.global_position - global_position).normalized()
				velocity = dir * 2500 
				is_grappling = true
		else:
			active_grapple.rpc("destroy_bullet")
			active_grapple = null
			rpc("force_reload", true)
	
	if is_on_floor():
		jumps_left = BODY_STATS[current_body].jumps
		if not was_on_floor and current_body == BodyType.HEAVY_WEIGHT:
			for p in get_tree().get_nodes_in_group("players"):
				if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 150:
					p.rpc_take_damage.rpc(15, name.to_int())
					p.rpc_pull.rpc(global_position, -300)
		
		if smash_active:
			smash_active = false
			rpc_ground_smash_fx.rpc()
	
	was_on_floor = is_on_floor()

	var wall_sliding = false
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			wall_sliding = true

	var gravity = base_gravity * BODY_STATS[current_body].grv

	if not is_on_floor() and not is_grappling and not jetpack_timer > 0 and not is_anchored:
		var current_grav = gravity
		
		if smash_active and velocity.y > 0: current_grav *= 10.0
		
		if wall_sliding and velocity.y > 0:
			current_grav = gravity/4
			velocity.y = minf(velocity.y, 350)
			
		if current_body == BodyType.FEATHER_FALLING and Input.is_action_pressed("ui_up") and velocity.y > 0:
			current_grav = gravity * 0.1
			velocity.y = minf(velocity.y, 100)
			
		if Input.is_action_pressed("ui_down"):
			current_grav *= 5.0 
			if wall_sliding and velocity.y > 0:
				velocity.y = maxf(velocity.y, 350)
				
		if current_body == BodyType.ARACHNID and is_on_ceiling() and Input.is_action_pressed("ui_up"):
			current_grav = 0
			velocity.y = 0
			jumps_left = 1
			
		velocity.y += current_grav * delta
	
	if not is_grappling and status_stasis_timer <= 0:
		if status_pin_timer <= 0 and not is_anchored:
			if Input.is_action_just_pressed("ui_up"):
				if is_on_floor() or jumps_left > 0 or (wall_sliding and current_body != BodyType.HEAVY_WEIGHT):
					if not is_on_floor() and not wall_sliding: jumps_left -= 1
					velocity.y = JUMP_VELOCITY * BODY_STATS[current_body].jmp
					animate_jump()
					if wall_sliding:
						velocity.x = 1100 if Input.is_action_pressed("ui_left") else -1100

			var direction = Input.get_axis("ui_left", "ui_right")
			var speed_modifier = current_speed * BODY_STATS[current_body].spd
			if rawwr_timer > 0: speed_modifier *= 1.5
			if shrink_timer > 0: speed_modifier *= 1.2
			
			if current_weapon == GunType.MINIGUN and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				speed_modifier *= 0.75 
				
			var friction = 200
			if current_body == BodyType.FROZEN_FEET: friction = 10 
				
			if nail_knockback_velocity.length() > 0: velocity = nail_knockback_velocity
			elif direction: velocity.x = move_toward(velocity.x, direction * speed_modifier, friction)
			elif not is_on_floor(): velocity.x = move_toward(velocity.x, 0, 30)
			else: velocity.x = move_toward(velocity.x, 0, friction)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed * 0.1) 

	move_and_slide()
	weapon_pivot.look_at(get_global_mouse_position())
	
	if nail_knockback_velocity.length() > 0:
		nail_knockback_velocity = nail_knockback_velocity.lerp(Vector2.ZERO, 10.0 * delta)
		if is_on_wall():
			status_pin_timer = 2.0 
			nail_knockback_velocity = Vector2.ZERO

	var stats = WEAPON_STATS[current_weapon]
	var wants_to_shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) if stats.auto else Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if current_weapon == GunType.CHARGE_GUN:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and ammo > 0 and can_shoot and status_stasis_timer <= 0:
			is_charging = true
			charge_level = min(charge_level + delta, 5.0) 
			return 
		elif is_charging:
			is_charging = false
			shoot(charge_level)
			charge_level = 0.0
			return
			
	if current_weapon == GunType.MINIGUN and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		minigun_heat = 0.0 

	if wants_to_shoot and ammo > 0 and can_shoot and status_stasis_timer <= 0:
		shoot()

func trigger_ability():
	ability_timer = ABILITY_CD[current_ability]
	rpc_use_ability.rpc(current_ability, get_global_mouse_position())

@rpc("any_peer", "call_local", "reliable")
func rpc_use_ability(ability_id, target_pos):
	match ability_id:
		AbilityType.DASH:
			var dir = (target_pos - global_position).normalized()
			velocity = dir * 3000
		AbilityType.SHIELD: temp_hp += 50
		AbilityType.REFLECT: is_reflecting = true; reflect_timer = 3.0
		AbilityType.SHRINK: shrink_timer = 5.0
		AbilityType.HEAL: hp = min(hp + 30, max_hp)
		AbilityType.WALL_DESTRUCT:
			if multiplayer.is_server():
				for w in get_tree().get_nodes_in_group("blocs"):
					if is_instance_valid(w) and global_position.distance_to(w.global_position) < 200:
						w.queue_free()
		AbilityType.TELEPORT:
			if global_position.distance_to(target_pos) < 600: global_position = target_pos
		AbilityType.SMASH:
			velocity.y = -800
			smash_active = true
		AbilityType.SWAP:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.SWAP
			get_tree().current_scene.add_child(b)
		AbilityType.SMOKE:
			if multiplayer.is_server():
				for p in get_tree().get_nodes_in_group("players"):
					if p != self and global_position.distance_to(p.global_position) < 250:
						p.rpc_apply_status.rpc("blind")
		AbilityType.ICE_WALL:
			if multiplayer.is_server(): rpc_spawn_object.rpc("ice", target_pos)
		AbilityType.MINES:
			if multiplayer.is_server(): rpc_spawn_object.rpc("mine", global_position)
		AbilityType.SHOCKWAVE:
			if multiplayer.is_server():
				for p in get_tree().get_nodes_in_group("players"):
					if p != self and global_position.distance_to(p.global_position) < 300:
						p.rpc_pull.rpc(global_position, -1500)
		AbilityType.ROLL:
			var dir = (target_pos - global_position).normalized()
			velocity = dir * 1500
			roll_timer = 0.5
		AbilityType.JETPACK: jetpack_timer = 3.0
		AbilityType.RAWWR: rawwr_timer = 5.0
		AbilityType.INVISIBILITY: invis_timer = 5.0
		AbilityType.FISHING_ROD:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.FISHING
			get_tree().current_scene.add_child(b)
		AbilityType.PROTECT_DOME:
			if multiplayer.is_server(): rpc_spawn_object.rpc("dome_protect", global_position)
		AbilityType.SOLID_DOME:
			if multiplayer.is_server(): rpc_spawn_object.rpc("dome_solid", global_position)
		AbilityType.STASIS:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.STASIS
			get_tree().current_scene.add_child(b)
		AbilityType.ANCHOR: is_anchored = true; anchor_timer = 5.0
		AbilityType.BLINK:
			global_position += Vector2(randf_range(-400, 400), randf_range(-400, 400))
		AbilityType.OVERCHARGE:
			hp -= 20
			ammo = max_ammo; update_ammo_ui()
		AbilityType.DECOY:
			if multiplayer.is_server(): rpc_spawn_object.rpc("decoy", global_position)

@rpc("any_peer", "call_local", "reliable")
func rpc_ground_smash_fx():
	if multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and global_position.distance_to(p.global_position) < 200:
				p.rpc_take_damage.rpc(30, name.to_int())
				p.rpc_pull.rpc(global_position, -1000)

@rpc("any_peer", "call_local", "reliable")
func rpc_spawn_object(type, pos):
	if type == "ice":
		var wall = StaticBody2D.new()
		wall.add_to_group("blocs")
		wall.position = pos
		var rect = ColorRect.new(); rect.color = Color.CYAN; rect.position = Vector2(-20, -100); rect.size = Vector2(40, 200); wall.add_child(rect)
		var coll = CollisionShape2D.new(); var shape = RectangleShape2D.new(); shape.size = Vector2(40, 200); coll.shape = shape; wall.add_child(coll)
		get_tree().current_scene.add_child(wall)
		get_tree().create_timer(10.0).timeout.connect(func(): if is_instance_valid(wall): wall.queue_free())
	
	elif type == "mine":
		var mine = Area2D.new()
		mine.position = pos
		var rect = ColorRect.new(); rect.color = Color.RED; rect.position = Vector2(-15, -5); rect.size = Vector2(30, 10); mine.add_child(rect)
		var coll = CollisionShape2D.new(); var shape = RectangleShape2D.new(); shape.size = Vector2(30, 10); coll.shape = shape; mine.add_child(coll)
		mine.body_entered.connect(func(body): 
			if body.has_method("rpc_take_damage") and body != self: 
				body.rpc_take_damage.rpc(40, name.to_int())
				mine.queue_free()
		)
		get_tree().current_scene.add_child(mine)
		
	elif type == "dome_protect":
		var dome = Area2D.new()
		dome.position = pos
		var coll = CollisionShape2D.new(); var shape = CircleShape2D.new(); shape.radius = 150; coll.shape = shape; dome.add_child(coll)
		dome.area_entered.connect(func(area): if area.is_in_group("bullets") and area.shooter != self: area.explode_or_die())
		get_tree().current_scene.add_child(dome)
		get_tree().create_timer(10.0).timeout.connect(func(): if is_instance_valid(dome): dome.queue_free())
		
	elif type == "dome_solid":
		for i in range(8):
			var angle = i * (PI / 4.0)
			var w_pos = pos + Vector2(cos(angle), sin(angle)) * 150
			rpc_spawn_object("ice", w_pos) 
			
	elif type == "decoy":
		var decoy = Sprite2D.new()
		decoy.texture = sprite.texture; decoy.modulate = sprite.modulate; decoy.position = pos
		get_tree().current_scene.add_child(decoy)
		var tween = create_tween()
		tween.tween_property(decoy, "position:x", pos.x + 800, 3.0)
		get_tree().create_timer(4.0).timeout.connect(func(): if is_instance_valid(decoy): decoy.queue_free())

func process_abilities(delta):
	if reflect_timer > 0:
		reflect_timer -= delta
		if reflect_timer <= 0: is_reflecting = false
	if shrink_timer > 0:
		shrink_timer -= delta
		sprite.scale = original_scale * 0.5
		if shrink_timer <= 0: sprite.scale = original_scale
	if anchor_timer > 0:
		anchor_timer -= delta
		if anchor_timer <= 0: is_anchored = false
	if jetpack_timer > 0:
		jetpack_timer -= delta
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_physical_key_pressed(KEY_E): velocity.y -= 2500 * delta
	if rawwr_timer > 0: rawwr_timer -= delta
	if roll_timer > 0: roll_timer -= delta
	if invis_timer > 0:
		invis_timer -= delta
		sprite.modulate.a = 0.2 
		if invis_timer <= 0: sprite.modulate.a = 1.0

func process_body_passives(delta):
	if multiplayer.is_server() and (current_body == BodyType.FIRE_AURA or current_body == BodyType.LIFESTEAL_AURA):
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 120:
				p.rpc_take_damage.rpc(5 * delta, name.to_int())
				if current_body == BodyType.LIFESTEAL_AURA: hp = min(hp + (5 * delta), max_hp)
					
	if current_body == BodyType.PASSIVE_REGEN and hp < max_hp:
		regen_timer += delta
		if regen_timer >= 1.0:
			hp = min(hp + 5, max_hp)
			regen_timer = 0.0
			
	if current_body == BodyType.CHANNELER and multiplayer.is_server():
		channeler_timer += delta
		if channeler_timer >= 3.0:
			channeler_timer = 0.0
			var closest = null; var dist = 300.0
			for p in get_tree().get_nodes_in_group("players"):
				if p != self and not p.is_dead and global_position.distance_to(p.global_position) < dist: closest = p
			if closest: closest.rpc_take_damage.rpc(15, name.to_int())
			
	if current_body == BodyType.STEALTH:
		if velocity.length() < 10: sprite.modulate.a = max(0.1, sprite.modulate.a - delta)
		else: sprite.modulate.a = 1.0

	if current_body == BodyType.SCUM and multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 80:
				p.rpc_apply_status.rpc("blind")

@rpc("any_peer", "call_local", "unreliable")
func rpc_update_mouse(pos): sync_mouse_pos = pos

func shoot(charge: float = 0.0):
	can_shoot = false 
	var stats = WEAPON_STATS[current_weapon]
	var fire_rate_mod = stats.fr
	
	if current_weapon == GunType.MINIGUN:
		minigun_heat = min(minigun_heat + 0.05, 1.0)
		fire_rate_mod = lerp(0.3, 0.02, minigun_heat)
		
	if current_weapon == GunType.TDE_BEAM: tde_heat = min(tde_heat + 0.15, 8.0) 
	else: tde_heat = 0.0
	
	for b in range(stats.burst):
		if ammo <= 0 or is_dead: break
		rpc_shoot_action.rpc(muzzle.global_position, weapon_pivot.rotation, current_weapon, charge, tde_heat)
		if stats.burst > 1: await get_tree().create_timer(0.08).timeout
			
	get_tree().create_timer(fire_rate_mod).timeout.connect(func(): can_shoot = true)

@rpc("any_peer", "call_local", "reliable")
func rpc_shoot_action(pos, rot, weapon_id, charge, tde_bonus):
	var stats = WEAPON_STATS[weapon_id]
	ammo -= 1
	animate_recoil(charge)
	update_ammo_ui()
	
	if stats.kb > 0 and is_multiplayer_authority() and current_body != BodyType.HEAVY_WEIGHT and not is_anchored:
		var push_dir = Vector2.RIGHT.rotated(rot + PI) 
		velocity += push_dir * stats.kb
		
	var hit_dist = 2000.0
	if stats.trait == Trait.BEAM:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(pos, pos + Vector2.RIGHT.rotated(rot) * 2000)
		query.collision_mask = 1 
		query.exclude = [self.get_rid()] 
		var result = space_state.intersect_ray(query)
		if result: hit_dist = pos.distance_to(result.position)
	
	for i in range(stats.pel):
		var bullet = bullet_scene.instantiate()
		bullet.shooter = self 
		bullet.global_position = pos
		bullet.rotation = rot + randf_range(-stats.spr, stats.spr)
		
		bullet.speed = stats.spd
		bullet.damage = stats.dmg + (charge / 5.0) * 84.0 
		if weapon_id == GunType.TDE_BEAM: bullet.damage *= pow(1.5, tde_bonus) 
		if rawwr_timer > 0: bullet.damage *= 1.5 
		
		bullet.scale = Vector2(stats.scl * (1.0 + charge * 2.0), stats.scl * (1.0 + charge * 2.0))
		bullet.b_trait = stats.trait; bullet.b_effect = stats.eff; bullet.bounces = stats.bnce; bullet.life_time = stats.life
		bullet.mass = stats.mass; bullet.grav_scale = stats.grav; bullet.beam_length = hit_dist
		
		get_tree().current_scene.add_child(bullet) 
		if stats.trait == Trait.GRAPPLE and is_multiplayer_authority(): active_grapple = bullet
	
	if stats.rl_type != 2:
		reload_timer.stop(); reload_delay_timer.stop(); reload_timer.wait_time = stats.rl
		if ammo <= 0: reload_timer.start()
		else: reload_delay_timer.start()

@rpc("any_peer", "call_local", "reliable")
func force_reload(instant):
	if instant: ammo = max_ammo; update_ammo_ui()
	else: reload_timer.wait_time = 8.0; reload_timer.start()

@rpc("any_peer", "call_local", "reliable")
func trigger_grapple_cooldown():
	active_grapple = null; reload_timer.wait_time = 1.5; reload_timer.start()

func _on_reload_delay_finished(): reload_timer.start()
func _on_reload_finished():
	var stats = WEAPON_STATS[current_weapon]
	minigun_heat = 0.0
	if stats.rl_type == 1:
		ammo += 1; update_ammo_ui()
		if ammo < max_ammo: reload_timer.start()
	else:
		ammo = max_ammo; update_ammo_ui()

func update_ammo_ui():
	for i in range(ammo_ui.get_child_count()): ammo_ui.get_child(i).modulate.a = 1.0 if i < ammo else 0.2 

func handle_status_effects(delta):
	if status_blind_timer > 0:
		status_blind_timer -= delta; sprite.modulate = Color.BLACK
	elif status_stasis_timer > 0:
		status_stasis_timer -= delta; sprite.modulate = Color.BLUE
	elif status_pin_timer > 0:
		status_pin_timer -= delta; sprite.modulate = Color.WEB_GRAY 
	elif status_slow_timer > 0:
		status_slow_timer -= delta; current_speed = BASE_SPEED * 0.75; sprite.modulate = Color.CYAN 
	else:
		current_speed = BASE_SPEED; sprite.modulate = original_color

func animate_jump():
	var tween = create_tween()
	sprite.scale = Vector2(original_scale.x * 0.5, original_scale.y * 1.5)
	tween.tween_property(sprite, "scale", original_scale, 0.3).set_trans(Tween.TRANS_ELASTIC)

func animate_recoil(charge_bonus: float = 0.0):
	if current_body == BodyType.HEAVY_WEIGHT: return 
	var tween = create_tween()
	gun_sprite.position.x = original_gun_pos.x - (15 + charge_bonus * 10.0) 
	tween.tween_property(gun_sprite, "position:x", original_gun_pos.x, 0.2).set_trans(Tween.TRANS_SPRING)

@rpc("any_peer", "call_local", "reliable")
func rpc_apply_status(type, dir = Vector2.ZERO, caster_id = -1):
	if type == "slow": status_slow_timer = 2.0
	elif type == "nail" and not is_anchored: nail_knockback_velocity = dir * 2500
	elif type == "blind": status_blind_timer = 1.0
	elif type == "stasis": status_stasis_timer = 3.0; stasis_caster = caster_id

@rpc("any_peer", "call_local", "reliable")
func rpc_pull(target_pos, force):
	if not is_multiplayer_authority() or is_anchored: return
	var dir = (target_pos - global_position).normalized()
	velocity = dir * force 

@rpc("any_peer", "call_local", "reliable")
func rpc_take_damage(amount, attacker_id = -1):
	if is_dead or roll_timer > 0: return 
	
	if status_stasis_timer > 0 and attacker_id == stasis_caster: return 
	
	if current_body == BodyType.INVINCIBLE and time_since_spawn < 5.0: return
	if current_body == BodyType.GAMBLER and randf() < 0.25: amount *= 0.5
	if current_body == BodyType.LAST_STAND and hp <= max_hp * 0.25: amount *= 0.5
	if current_body == BodyType.BOMBER and attacker_id == name.to_int(): return
	
	if temp_hp > 0:
		temp_hp -= amount
		if temp_hp < 0:
			amount = abs(temp_hp)
			temp_hp = 0
		else: return 
	
	if current_body == BodyType.TURTLE and attacker_id != -1:
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker:
			var dir_to_attacker = sign(attacker.global_position.x - global_position.x)
			var facing_dir = sign(get_global_mouse_position().x - global_position.x)
			if dir_to_attacker == facing_dir: amount *= 0.5 
			
	if current_body == BodyType.UNSTABLE and randf() < 0.15:
		global_position += Vector2(randf_range(-200, 200), randf_range(-200, -50))
		amount = 0
	
	hp -= amount
	
	if current_body == BodyType.REACTIVE_ARMOR and hp < max_hp * 0.5 and not reactive_triggered:
		reactive_triggered = true
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and global_position.distance_to(p.global_position) < 200: p.rpc_pull.rpc(global_position, -800) 
				
	if current_body == BodyType.THORNS and attacker_id != -1 and attacker_id != name.to_int():
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker: attacker.rpc_take_damage.rpc(amount * 0.2, name.to_int())
		
	if current_body == BodyType.ACID_BLOOD and attacker_id != -1:
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker: attacker.rpc_apply_status.rpc("slow")
		
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "modulate", original_color, 0.2) 
	
	if hp <= 0:
		if attacker_id != -1:
			var attacker = get_parent().get_node_or_null(str(attacker_id))
			if attacker and attacker.current_body == BodyType.VAMPIRE_BODY: attacker.hp = min(attacker.hp + 30, attacker.max_hp)
		die()

func die():
	is_dead = true; hide(); hp_bar.hide(); ammo_ui.hide(); collision_shape.set_deferred("disabled", true) 
	if is_instance_valid(active_grapple): active_grapple.rpc("destroy_bullet")
	get_tree().create_timer(3.0).timeout.connect(respawn)

func respawn():
	global_position = spawn_position; hp = max_hp; ammo = max_ammo; is_dead = false
	status_pin_timer = 0; status_slow_timer = 0; status_blind_timer = 0; time_since_spawn = 0.0; reactive_triggered = false
	nail_knockback_velocity = Vector2.ZERO; collision_shape.set_deferred("disabled", false) 
	update_ammo_ui(); hp_bar.show(); ammo_ui.show(); show()
