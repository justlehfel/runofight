extends CharacterBody2D

enum GunType { BUCKSHOT, SNIPER, AUTO_RIFLE, SMG, BURST_PISTOL, REVOLVER, LIGHTNING_GUN, GRAPPLING_HOOK, FLAMETHROWER, CHARGE_GUN, SORCERER_WAND, GRENADE_LAUNCHER, BOW, PLASMA_CANNON, SAWED_OFF, NAILGUN, TDE_BEAM, TRACTOR_BEAM, DISC_LAUNCHER, ROCKET_LAUNCHER, BOOMERANG, ENERGY_WHIP, MINIGUN, HARPOON, SLUSH_LAUNCHER }
enum BodyType { DEFAULT, PASSIVE_REGEN, GIANT, THORNS, TRIPLE_JUMP, FEATHER_WEIGHT, HEAVY_WEIGHT, AERODYNAMIC, FROZEN_FEET, COLD_BLOOD, REACTIVE_ARMOR, MICROBE, INVINCIBLE, VAMPIRE_BODY, FIRE_AURA, POISON_TOUCH, LIFESTEAL_AURA, BOMBER, LAST_STAND, FEATHER_FALLING, SCUM, STEALTH, GAMBLER, CHANNELER, ARACHNID, TURTLE, UNSTABLE }
enum AbilityType { DASH, SHIELD, REFLECT, SHRINK, HEAL, WALL_DESTRUCT, TELEPORT, SMASH, SWAP, SMOKE, ICE_WALL, MINES, SHOCKWAVE, ROLL, JETPACK, RAWWR, INVISIBILITY, FISHING_ROD, PROTECT_DOME, SOLID_DOME, STASIS, ANCHOR, BLINK, OVERCHARGE, DECOY }
enum Trait { NORMAL, BOOMERANG, HOMING, PIERCE, BEAM, CHAIN_BULLET, GRAPPLE, REMOTE, HARPOON, FLAME, SWAP, STASIS, FISHING }
enum Effect { NONE, EXPLOSION, SLOW, NAIL_STUN, PULL_ENEMY, PULL_SELF }

const WEAPON_STATS = {
	GunType.BUCKSHOT: { "ammo": 2, "fr": 0.8, "dmg": 7.5, "spd": 1800, "spr": 0.25, "pel": 6, "scl": 0.5, "auto": false, "rl": 2.2, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.4, "kb": 500, "burst": 1, "mass": 2.0, "grav": 0.0, "rl_type": 1 },
	GunType.SNIPER: { "ammo": 1, "fr": 1.5, "dmg": 42.5, "spd": 2000, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 400, "burst": 1, "mass": 10.0, "grav": 1.0, "rl_type": 0 },
	GunType.AUTO_RIFLE: { "ammo": 25, "fr": 0.24, "dmg": 6.0, "spd": 1500, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": true, "rl": 4.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 50, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.SMG: { "ammo": 40, "fr": 0.07, "dmg": 3.5, "spd": 1300, "spr": 0.15, "pel": 1, "scl": 0.6, "auto": true, "rl": 3.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 20, "burst": 1, "mass": 1.5, "grav": 1.0, "rl_type": 0 },
	GunType.BURST_PISTOL: { "ammo": 12, "fr": 0.5, "dmg": 9.0, "spd": 1200, "spr": 0.05, "pel": 1, "scl": 0.8, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 0, "burst": 3, "mass": 2.5, "grav": 1.0, "rl_type": 0 },
	GunType.REVOLVER: { "ammo": 6, "fr": 0.8, "dmg": 29.68, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 3.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 100, "burst": 1, "mass": 4.0, "grav": 1.0, "rl_type": 0 },
	GunType.LIGHTNING_GUN: { "ammo": 5, "fr": 1.0, "dmg": 7.5, "spd": 3500, "spr": 0.0, "pel": 1, "scl": 0.8, "auto": false, "rl": 3.0, "trait": Trait.CHAIN_BULLET, "eff": Effect.NONE, "bnce": 0, "life": 0.5, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.GRAPPLING_HOOK: { "ammo": 1, "fr": 1.0, "dmg": 6.6, "spd": 3500, "spr": 0.0, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.GRAPPLE, "eff": Effect.NONE, "bnce": 0, "life": 1.5, "kb": 0, "burst": 1, "mass": 5.0, "grav": 1.0, "rl_type": 2 },
	GunType.FLAMETHROWER: { "ammo": 60, "fr": 0.05, "dmg": 1.2, "spd": 400, "spr": 0.3, "pel": 2, "scl": 1.5, "auto": true, "rl": 3.0, "trait": Trait.FLAME, "eff": Effect.NONE, "bnce": 0, "life": 0.4, "kb": 10, "burst": 1, "mass": 0.5, "grav": 0.0, "rl_type": 0 },
	GunType.CHARGE_GUN: { "ammo": 1, "fr": 0.1, "dmg": 1.0, "spd": 2500, "spr": 0.0, "pel": 1, "scl": 0.2, "auto": false, "rl": 0.1, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 50, "burst": 1, "mass": 8.0, "grav": 1.0, "rl_type": 0 },
	GunType.SORCERER_WAND: { "ammo": 1, "fr": 0.5, "dmg": 30.4, "spd": 600, "spr": 0.0, "pel": 1, "scl": 0.9, "auto": false, "rl": 0.0, "trait": Trait.REMOTE, "eff": Effect.NONE, "bnce": 0, "life": 5.0, "kb": 0, "burst": 1, "mass": 2.0, "grav": 1.0, "rl_type": 2 },
	GunType.GRENADE_LAUNCHER: { "ammo": 3, "fr": 0.9, "dmg": 10.0, "spd": 800, "spr": 0.1, "pel": 1, "scl": 1.2, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 1, "life": 10.0, "kb": 150, "burst": 1, "mass": 6.0, "grav": 1.0, "rl_type": 0 },
	GunType.BOW: { "ammo": 1, "fr": 1.0, "dmg": 45.0, "spd": 1600, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 0, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.PLASMA_CANNON: { "ammo": 3, "fr": 1.2, "dmg": 60.0, "spd": 400, "spr": 0.0, "pel": 1, "scl": 3.5, "auto": false, "rl": 2.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 200, "burst": 1, "mass": 20.0, "grav": 0.0, "rl_type": 0 },
	GunType.SAWED_OFF: { "ammo": 2, "fr": 0.16, "dmg": 4.68, "spd": 1100, "spr": 0.4, "pel": 10, "scl": 0.5, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 0.15, "kb": 600, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 },
	GunType.NAILGUN: { "ammo": 1, "fr": 0.3, "dmg": 25.6, "spd": 2200, "spr": 0.0, "pel": 1, "scl": 0.5, "auto": false, "rl": 1.5, "trait": Trait.NORMAL, "eff": Effect.NAIL_STUN, "bnce": 0, "life": 10.0, "kb": 0, "burst": 1, "mass": 2.0, "grav": 1.0, "rl_type": 0 },
	GunType.TDE_BEAM: { "ammo": 40, "fr": 0.05, "dmg": 0.1, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.5, "auto": true, "rl": 2.5, "trait": Trait.BEAM, "eff": Effect.NONE, "bnce": 0, "life": 0.05, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.TRACTOR_BEAM: { "ammo": 30, "fr": 0.1, "dmg": 1.5, "spd": 5000, "spr": 0.0, "pel": 1, "scl": 0.6, "auto": true, "rl": 2.0, "trait": Trait.BEAM, "eff": Effect.PULL_ENEMY, "bnce": 0, "life": 0.1, "kb": 0, "burst": 1, "mass": 1.0, "grav": 0.0, "rl_type": 0 },
	GunType.DISC_LAUNCHER: { "ammo": 5, "fr": 0.6, "dmg": 15.0, "spd": 900, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.8, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 3, "life": 10.0, "kb": 0, "burst": 1, "mass": 7.0, "grav": 1.0, "rl_type": 0 },
	GunType.ROCKET_LAUNCHER: { "ammo": 1, "fr": 1.5, "dmg": 21.1, "spd": 700, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.5, "trait": Trait.NORMAL, "eff": Effect.EXPLOSION, "bnce": 0, "life": 10.0, "kb": 300, "burst": 1, "mass": 15.0, "grav": 0.0, "rl_type": 0 },
	GunType.BOOMERANG: { "ammo": 1, "fr": 1.0, "dmg": 20.0, "spd": 1200, "spr": 0.0, "pel": 1, "scl": 1.2, "auto": false, "rl": 0.0, "trait": Trait.BOOMERANG, "eff": Effect.NONE, "bnce": 0, "life": 0.9, "kb": 0, "burst": 1, "mass": 6.0, "grav": 1.0, "rl_type": 2 },
	GunType.ENERGY_WHIP: { "ammo": 8, "fr": 0.2, "dmg": 4.37, "spd": 3000, "spr": 0.0, "pel": 1, "scl": 1.0, "auto": false, "rl": 1.5, "trait": Trait.PIERCE, "eff": Effect.NONE, "bnce": 0, "life": 0.08, "kb": 0, "burst": 1, "mass": 1.0, "grav": 1.0, "rl_type": 0 },
	GunType.MINIGUN: { "ammo": 100, "fr": 0.15, "dmg": 2.4, "spd": 1600, "spr": 0.25, "pel": 1, "scl": 0.7, "auto": true, "rl": 4.0, "trait": Trait.NORMAL, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 80, "burst": 1, "mass": 1.2, "grav": 1.0, "rl_type": 0 },
	GunType.HARPOON: { "ammo": 1, "fr": 1.2, "dmg": 20.0, "spd": 1800, "spr": 0.0, "pel": 1, "scl": 1.5, "auto": false, "rl": 2.0, "trait": Trait.HARPOON, "eff": Effect.NONE, "bnce": 0, "life": 10.0, "kb": 0, "burst": 1, "mass": 8.0, "grav": 1.0, "rl_type": 0 },
	GunType.SLUSH_LAUNCHER: { "ammo": 10, "fr": 0.4, "dmg": 9.0, "spd": 900, "spr": 0.1, "pel": 1, "scl": 0.8, "auto": false, "rl": 2.0, "trait": Trait.NORMAL, "eff": Effect.SLOW, "bnce": 0, "life": 10.0, "kb": 0, "burst": 1, "mass": 3.0, "grav": 1.0, "rl_type": 0 }
}

const BODY_STATS = {
	BodyType.DEFAULT: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.PASSIVE_REGEN: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.GIANT: { "hp": 150, "spd": 0.8, "jmp": 0.9, "grv": 1.2, "scl": 1.6, "air_jumps": 0 },
	BodyType.THORNS: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.TRIPLE_JUMP: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 2 },
	BodyType.FEATHER_WEIGHT: { "hp": 80, "spd": 1.1, "jmp": 1.3, "grv": 0.6, "scl": 1.0, "air_jumps": 0 },
	BodyType.HEAVY_WEIGHT: { "hp": 130, "spd": 0.85, "jmp": 0.75, "grv": 1.8, "scl": 1.0, "air_jumps": 0 },
	BodyType.AERODYNAMIC: { "hp": 100, "spd": 1.35, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.FROZEN_FEET: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.COLD_BLOOD: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.REACTIVE_ARMOR: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.MICROBE: { "hp": 70, "spd": 1.2, "jmp": 1.1, "grv": 0.8, "scl": 0.5, "air_jumps": 0 },
	BodyType.INVINCIBLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.VAMPIRE_BODY: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.FIRE_AURA: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.POISON_TOUCH: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.LIFESTEAL_AURA: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.BOMBER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.LAST_STAND: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.FEATHER_FALLING: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.SCUM: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.STEALTH: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.GAMBLER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.CHANNELER: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.ARACHNID: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.TURTLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 },
	BodyType.UNSTABLE: { "hp": 100, "spd": 1.0, "jmp": 1.0, "grv": 1.0, "scl": 1.0, "air_jumps": 0 }
}

const ABILITY_CD = {
	AbilityType.DASH: 3.4, AbilityType.SHIELD: 12.0, AbilityType.REFLECT: 15.0, AbilityType.SHRINK: 12.0, AbilityType.HEAL: 15.0,
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
var air_jumps_left = 0

var ammo = 0
var max_ammo = 0
var can_shoot: bool = true
var spawn_position: Vector2
var is_dead: bool = false

var current_speed = BASE_SPEED
var status_slow_timer = 0.0
var status_pin_timer = 0.0
var status_blind_timer = 0.0
var status_stasis_timer = 0.0
var status_tractor_timer = 0.0
var poison_timer = 0.0
var poison_tick = 0.0
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
var jetpack_fuel = 4.0
var smash_active = false
var invis_timer = 0.0

var time_passed = 0.0

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

func _enter_tree(): set_multiplayer_authority(name.to_int())

func _ready():
	add_to_group("players")
	original_color = sprite.modulate
	base_sprite_scale = sprite.scale
	
	var my_peer_id = name.to_int()
	if GameManager.players.has(my_peer_id):
		current_weapon = GameManager.players[my_peer_id]["weapon"]
		current_body = GameManager.players[my_peer_id]["body"]
		current_ability = GameManager.players[my_peer_id]["ability"]
		var sorted_ids = GameManager.players.keys(); sorted_ids.sort()
		var index = sorted_ids.find(my_peer_id); var total_players = sorted_ids.size()
		var spawn_x = 960
		match total_players:
			1: spawn_x = 960
			2: spawn_x = [400, 1500][index]
			3: spawn_x = [300, 960, 1620][index]
			4: spawn_x = [200, 700, 1220, 1720][index]
			_: spawn_x = 200 + (index * 400)
		global_position = Vector2(spawn_x, 50)
		collision_shape.set_deferred("disabled", true)
		get_tree().create_timer(0.2).timeout.connect(func(): if not is_dead: collision_shape.set_deferred("disabled", false))
	
	spawn_position = global_position 
	equip_runes() 
	
	reload_timer = Timer.new(); reload_timer.one_shot = true; reload_timer.timeout.connect(_on_reload_finished); add_child(reload_timer)
	reload_delay_timer = Timer.new(); reload_delay_timer.wait_time = 1.0; reload_delay_timer.one_shot = true; reload_delay_timer.timeout.connect(_on_reload_delay_finished); add_child(reload_delay_timer)
	reload_circle.hide()
	
	if is_multiplayer_authority() and has_node("Camera2D"): $Camera2D.make_current()

	if GameManager.players.has(my_peer_id):
		var p_data = GameManager.players[my_peer_id]
		var name_tag = Label.new()
		name_tag.text = p_data["name"]
		name_tag.modulate = Color(p_data["color"]) 
		name_tag.set_anchors_preset(Control.PRESET_CENTER_TOP)
		name_tag.position = Vector2(-100, -90)
		name_tag.custom_minimum_size = Vector2(200, 30)
		name_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_tag.add_theme_font_size_override("font_size", 20)
		name_tag.add_theme_color_override("font_outline_color", Color.BLACK)
		name_tag.add_theme_constant_override("outline_size", 4)
		add_child(name_tag)

func equip_runes():
	var g_stats = WEAPON_STATS[current_weapon]; var b_stats = BODY_STATS[current_body]
	max_hp = b_stats.hp; hp = max_hp; hp_bar.max_value = max_hp; temp_hp = 0.0
	
	var current_scale_mult = b_stats.scl
	original_scale = base_sprite_scale * current_scale_mult
	sprite.scale = original_scale
	collision_shape.scale = Vector2(current_scale_mult, current_scale_mult)
	
	max_ammo = g_stats.ammo; charge_level = 0.0; is_charging = false; active_grapple = null
	minigun_heat = 0.0; ability_timer = 0.0; jetpack_fuel = 4.0; invis_timer = 0.0
	
	for child in ammo_ui.get_children(): ammo_ui.remove_child(child); child.queue_free()
	for i in range(max_ammo):
		var rect = ColorRect.new(); rect.custom_minimum_size = Vector2(8, 8); rect.color = Color.YELLOW; ammo_ui.add_child(rect)
	ammo = max_ammo; update_ammo_ui()

func _physics_process(delta):
	if multiplayer.multiplayer_peer == null: return 
	time_since_spawn += delta
	time_passed += delta
	if is_dead: return 
	
	queue_redraw()

	if not GameManager.match_active:
		velocity.y += base_gravity * BODY_STATS[current_body].grv * delta
		velocity.x = move_toward(velocity.x, 0, 200)
		move_and_slide()
		return

	if current_ability == AbilityType.JETPACK:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_physical_key_pressed(KEY_E):
			if jetpack_fuel > 0 and ability_timer <= 0:
				jetpack_fuel -= delta; velocity.y -= 2500 * delta
				if jetpack_fuel <= 0: ability_timer = ABILITY_CD[current_ability]
		if ability_timer > 0:
			ability_timer -= delta
			if ability_timer <= 0: jetpack_fuel = 4.0
	else:
		if ability_timer > 0: ability_timer -= delta

	handle_status_effects(delta)
	process_body_passives(delta)
	process_abilities(delta)
	process_procedural_animations(delta)

	hp_bar.value = hp
	if not reload_timer.is_stopped(): reload_circle.show(); reload_circle.value = (1.0 - (reload_timer.time_left / reload_timer.wait_time)) * 100
	else: reload_circle.hide()

	if not is_multiplayer_authority(): return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_physical_key_pressed(KEY_E):
		if ability_timer <= 0 and status_stasis_timer <= 0 and current_ability != AbilityType.JETPACK:
			trigger_ability()

	var current_mouse = get_global_mouse_position()
	if current_mouse.distance_to(sync_mouse_pos) > 5.0: sync_mouse_pos = current_mouse; rpc_update_mouse.rpc(sync_mouse_pos)

	var is_grappling = false
	if current_weapon == GunType.GRAPPLING_HOOK and is_instance_valid(active_grapple):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if active_grapple.is_stuck:
				velocity = (active_grapple.global_position - global_position).normalized() * 2500 
				is_grappling = true
		else: active_grapple.rpc("destroy_bullet"); active_grapple = null; rpc("force_reload", true)
	
	if is_on_floor():
		air_jumps_left = BODY_STATS[current_body].air_jumps
		if not was_on_floor and current_body == BodyType.HEAVY_WEIGHT:
			for p in get_tree().get_nodes_in_group("players"):
				if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 150:
					p.rpc_take_damage.rpc(15, name.to_int())
					p.rpc_pull.rpc(global_position, -300)
		if not was_on_floor and not smash_active and velocity.y > 100: animate_landing()
		if smash_active: smash_active = false; rpc_ground_smash_fx.rpc()
	was_on_floor = is_on_floor()

	var wall_sliding = false
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"): wall_sliding = true

	var gravity = base_gravity * BODY_STATS[current_body].grv

	if not is_on_floor() and not is_grappling and not (current_ability == AbilityType.JETPACK and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and jetpack_fuel > 0 and ability_timer <= 0) and not is_anchored:
		var current_grav = gravity
		if smash_active and velocity.y > 0: current_grav *= 10.0
		if wall_sliding and velocity.y > 0: current_grav = gravity/4; velocity.y = minf(velocity.y, 350)
		if current_body == BodyType.FEATHER_FALLING and Input.is_action_pressed("ui_up") and velocity.y > 0:
			current_grav = gravity * 0.1; velocity.y = minf(velocity.y, 100)
		if Input.is_action_pressed("ui_down"):
			current_grav *= 5.0 
			if wall_sliding and velocity.y > 0: velocity.y = maxf(velocity.y, 350)
		if current_body == BodyType.ARACHNID and is_on_ceiling() and Input.is_action_pressed("ui_up"):
			current_grav = 0; velocity.y = 0; air_jumps_left = 1
		velocity.y += current_grav * delta
	
	if not is_grappling and status_stasis_timer <= 0:
		if status_pin_timer <= 0 and not is_anchored:
			if Input.is_action_just_pressed("ui_up") and status_tractor_timer <= 0:
				if is_on_floor() or air_jumps_left > 0 or (wall_sliding and current_body != BodyType.HEAVY_WEIGHT):
					if not is_on_floor() and not wall_sliding: air_jumps_left -= 1
					velocity.y = JUMP_VELOCITY * BODY_STATS[current_body].jmp
					animate_jump()
					if wall_sliding: velocity.x = 1100 if Input.is_action_pressed("ui_left") else -1100

			var direction = 0.0 if status_tractor_timer > 0 else Input.get_axis("ui_left", "ui_right")
			var arena_buff = 1.0
			for d in get_tree().get_nodes_in_group("arena_domes"):
				if global_position.distance_to(d.global_position) < 600:
					arena_buff = 1.25 if d.get_meta("caster") == name.to_int() else 0.85
			
			var speed_modifier = current_speed * BODY_STATS[current_body].spd * arena_buff
			if rawwr_timer > 0: speed_modifier *= 1.5
			if shrink_timer > 0: speed_modifier *= 1.2
			if current_weapon == GunType.MINIGUN and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): speed_modifier *= 0.75 
				
			var friction = 200
			if current_body == BodyType.FROZEN_FEET: friction = 10 
				
			if nail_knockback_velocity.length() > 0: velocity = nail_knockback_velocity
			elif direction: velocity.x = move_toward(velocity.x, direction * speed_modifier, friction)
			elif not is_on_floor(): velocity.x = move_toward(velocity.x, 0, 10)
			else: velocity.x = move_toward(velocity.x, 0, friction)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed * 0.1) 

	move_and_slide()
	weapon_pivot.look_at(get_global_mouse_position())
	
	if nail_knockback_velocity.length() > 0:
		nail_knockback_velocity = nail_knockback_velocity.lerp(Vector2.ZERO, 10.0 * delta)
		if is_on_wall() and velocity.length() > 500:
			status_pin_timer = 2.0; nail_knockback_velocity = Vector2.ZERO
			rpc_apply_status.rpc("pin") 

	var stats = WEAPON_STATS[current_weapon]
	var wants_to_shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) if stats.auto else Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if current_weapon == GunType.CHARGE_GUN:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and ammo > 0 and can_shoot and status_stasis_timer <= 0:
			is_charging = true; charge_level = min(charge_level + delta, 5.0); return 
		elif is_charging:
			is_charging = false; shoot(charge_level); charge_level = 0.0; return
			
	if current_weapon == GunType.MINIGUN and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): minigun_heat = 0.0 
	if wants_to_shoot and ammo > 0 and can_shoot and status_stasis_timer <= 0: shoot()

func _draw():
	if status_blind_timer > 0 and is_multiplayer_authority(): 
		draw_rect(Rect2(-2000, -2000, 4000, 4000), Color(0, 0, 0, 0.95))
		
	if temp_hp > 0:
		var shield_w = (temp_hp / max_hp) * hp_bar.size.x
		draw_rect(Rect2(hp_bar.position.x, hp_bar.position.y - 8, shield_w, 6), Color(0.2, 0.6, 1.0, 0.9))
	
	var ratio = 1.0
	var outline_color = Color(1.0, 0.2, 0.8)
	if current_ability == AbilityType.JETPACK:
		ratio = jetpack_fuel / 4.0; outline_color = Color(1.0, 0.8, 0.2)
	else:
		var cd = ABILITY_CD[current_ability]
		ratio = 1.0 - (ability_timer / cd) if ability_timer > 0 else 1.0

	var padding = 2.0
	var rect_pos = hp_bar.position - Vector2(padding, padding)
	var rect_size = hp_bar.size + Vector2(padding * 2, padding * 2)
	
	var w = rect_size.x; var h = rect_size.y
	var perimeter = (2 * w) + (2 * h)
	var target_dist = ratio * perimeter
	
	var p0 = rect_pos; var p1 = rect_pos + Vector2(w, 0); var p2 = rect_pos + Vector2(w, h); var p3 = rect_pos + Vector2(0, h)
	var points = [p0, p1, p2, p3, p0]
	var thickness = 2.0
	
	if ratio >= 1.0:
		draw_rect(Rect2(rect_pos, rect_size), outline_color, false, thickness)
		var glow_rect = Rect2(rect_pos - Vector2(2, 2), rect_size + Vector2(4, 4))
		var glow_color = Color(outline_color.r, outline_color.g, outline_color.b, 0.4)
		draw_rect(glow_rect, glow_color, false, thickness + 2.0)
	elif target_dist > 0:
		var current_dist = target_dist; var drawn_points = [p0]
		for i in range(4):
			var segment_len = (points[i+1] - points[i]).length()
			if current_dist >= segment_len: drawn_points.append(points[i+1]); current_dist -= segment_len
			else: drawn_points.append(points[i] + (points[i+1] - points[i]).normalized() * current_dist); break 
		for i in range(drawn_points.size() - 1): draw_line(drawn_points[i], drawn_points[i+1], outline_color, thickness)

	if current_body == BodyType.FIRE_AURA: draw_circle(Vector2.ZERO, 300, Color(1, 0.5, 0, 0.1))
	if rawwr_timer > 0: draw_circle(Vector2.ZERO, 50, Color(1, 0, 0, 0.3))

func process_procedural_animations(delta):
	if is_dead: return
	
	var base_scl = base_sprite_scale * BODY_STATS[current_body].scl
	if shrink_timer > 0: base_scl *= 0.5
		
	var target_rotation = velocity.x * 0.0003 if not is_anchored else 0.0
	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, delta * 12.0)
	
	if is_on_floor() and abs(velocity.x) < 10:
		sprite.scale.y = lerp(sprite.scale.y, base_scl.y * (1.0 + sin(time_passed * 4.0) * 0.05), delta * 8.0)
		sprite.scale.x = lerp(sprite.scale.x, base_scl.x * (1.0 - sin(time_passed * 4.0) * 0.02), delta * 8.0)
	elif is_on_floor():
		sprite.scale = sprite.scale.lerp(base_scl, delta * 15.0)
	else:
		var stretch = clamp(velocity.y * 0.0005, -0.2, 0.2)
		sprite.scale.y = lerp(sprite.scale.y, base_scl.y * (1.0 + stretch), delta * 15.0)
		sprite.scale.x = lerp(sprite.scale.x, base_scl.x * (1.0 - stretch), delta * 15.0)

func animate_jump():
	var tw = create_tween()
	var scl = base_sprite_scale * BODY_STATS[current_body].scl * (0.5 if shrink_timer > 0 else 1.0)
	sprite.scale = Vector2(scl.x * 0.5, scl.y * 1.5)
	tw.tween_property(sprite, "scale", scl, 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func animate_landing():
	var tw = create_tween()
	var scl = base_sprite_scale * BODY_STATS[current_body].scl * (0.5 if shrink_timer > 0 else 1.0)
	sprite.scale = Vector2(scl.x * 1.4, scl.y * 0.6)
	tw.tween_property(sprite, "scale", scl, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func animate_recoil(charge_bonus: float = 0.0):
	if current_body == BodyType.HEAVY_WEIGHT: return 
	var tw = create_tween()
	gun_sprite.position.x = original_gun_pos.x - (15 + charge_bonus * 10.0) 
	tw.tween_property(gun_sprite, "position:x", original_gun_pos.x, 0.2).set_trans(Tween.TRANS_SPRING)

func trigger_ability():
	if current_ability != AbilityType.JETPACK: ability_timer = ABILITY_CD[current_ability]
	rpc_use_ability.rpc(current_ability, get_global_mouse_position())

@rpc("any_peer", "call_local", "reliable")
func rpc_use_ability(ability_id, target_pos):
	if ability_id != AbilityType.JETPACK:
		var ghost = Sprite2D.new(); ghost.texture = sprite.texture; ghost.global_position = sprite.global_position
		ghost.scale = sprite.scale; ghost.rotation = sprite.rotation; ghost.modulate = Color(1.0, 0.2, 0.8, 0.8)
		get_tree().current_scene.add_child(ghost)
		var tw = create_tween().set_parallel(true)
		tw.tween_property(ghost, "scale", ghost.scale * 2.0, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tw.tween_property(ghost, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tw.chain().tween_callback(ghost.queue_free)
		
	match ability_id:
		AbilityType.DASH: velocity = (target_pos - global_position).normalized() * 1500
		AbilityType.SHIELD: temp_hp += 50
		AbilityType.REFLECT: is_reflecting = true; reflect_timer = 3.0
		AbilityType.SHRINK:
			shrink_timer = 5.0
			var scl = base_sprite_scale * BODY_STATS[current_body].scl * 0.5
			sprite.scale = scl; collision_shape.scale = Vector2(scl.x, scl.y)
		AbilityType.HEAL: rpc_apply_heal(max_hp * 0.5)
		AbilityType.WALL_DESTRUCT:
			if multiplayer.is_server():
				for w in get_tree().get_nodes_in_group("blocs"):
					if is_instance_valid(w) and global_position.distance_to(w.global_position) < 200: w.queue_free()
		AbilityType.TELEPORT:
			if global_position.distance_to(target_pos) > 600: target_pos = global_position + (target_pos - global_position).normalized() * 600
			global_position = target_pos
		AbilityType.SMASH:
			if is_on_floor(): velocity.y = -1000; get_tree().create_timer(0.3).timeout.connect(func(): smash_active = true)
			else: smash_active = true
		AbilityType.SWAP:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.SWAP; b.speed = 2500
			get_tree().current_scene.add_child(b)
		AbilityType.SMOKE: if multiplayer.is_server(): rpc_spawn_object.rpc("smoke", target_pos)
		AbilityType.ICE_WALL: if multiplayer.is_server(): rpc_spawn_object.rpc("ice", target_pos)
		AbilityType.MINES: if multiplayer.is_server(): rpc_spawn_object.rpc("mine", global_position)
		AbilityType.SHOCKWAVE:
			if multiplayer.is_server():
				for p in get_tree().get_nodes_in_group("players"):
					if p != self and global_position.distance_to(p.global_position) < 300: p.rpc_pull.rpc(global_position, -3000)
		AbilityType.ROLL:
			if is_on_floor(): velocity = (target_pos - global_position).normalized() * 1500; roll_timer = 0.5
		AbilityType.RAWWR: rawwr_timer = 5.0
		AbilityType.INVISIBILITY: invis_timer = 5.0
		AbilityType.FISHING_ROD:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.FISHING; b.speed = 3000
			get_tree().current_scene.add_child(b)
		AbilityType.PROTECT_DOME: if multiplayer.is_server(): rpc_spawn_object.rpc("dome_protect", global_position)
		AbilityType.SOLID_DOME: if multiplayer.is_server(): rpc_spawn_object.rpc("dome_solid", global_position)
		AbilityType.STASIS:
			var b = bullet_scene.instantiate()
			b.shooter = self; b.global_position = muzzle.global_position; b.rotation = weapon_pivot.rotation; b.b_trait = Trait.STASIS
			get_tree().current_scene.add_child(b)
		AbilityType.ANCHOR: is_anchored = true; anchor_timer = 5.0; velocity.y = 2000
		AbilityType.BLINK:
			sprite.hide(); hp_bar.hide(); ammo_ui.hide(); gun_sprite.hide(); collision_shape.set_deferred("disabled", true); is_dead = true
			get_tree().create_timer(1.5).timeout.connect(func():
				is_dead = false; sprite.show(); hp_bar.show(); ammo_ui.show(); gun_sprite.show(); collision_shape.set_deferred("disabled", false)
				var space = get_world_2d().direct_space_state
				var tp_pos = global_position + Vector2(randf_range(-400, 400), randf_range(-400, 400))
				var query = PhysicsRayQueryParameters2D.create(global_position, tp_pos); var res = space.intersect_ray(query)
				if res: tp_pos = res.position - (tp_pos - global_position).normalized() * 30
				global_position = tp_pos
			)
		AbilityType.OVERCHARGE: hp -= 20; ammo = max_ammo; update_ammo_ui()
		AbilityType.DECOY: if multiplayer.is_server(): rpc_spawn_object.rpc("decoy", global_position)

@rpc("any_peer", "call_local", "reliable")
func rpc_apply_heal(amount):
	if current_body == BodyType.PASSIVE_REGEN: amount *= 0.9
	hp = min(hp + amount, max_hp)
	spawn_floating_text_local("+" + str(int(amount)), Color.GREEN)

@rpc("any_peer", "call_local", "reliable")
func rpc_ground_smash_fx():
	if multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and global_position.distance_to(p.global_position) < 200:
				p.rpc_take_damage.rpc(p.max_hp * 0.25, name.to_int())
				p.rpc_pull.rpc(global_position, -800)

@rpc("any_peer", "call_local", "reliable")
func rpc_spawn_object(type, pos):
	if type == "ice":
		var wall = StaticBody2D.new(); wall.add_to_group("blocs"); wall.position = pos; wall.set_meta("hp", 150.0)
		var rect = ColorRect.new(); rect.color = Color.CYAN; rect.position = Vector2(-20, -100); rect.size = Vector2(40, 200); wall.add_child(rect)
		var coll = CollisionShape2D.new(); var shape = RectangleShape2D.new(); shape.size = Vector2(40, 200); coll.shape = shape; wall.add_child(coll)
		get_tree().current_scene.add_child(wall)
	elif type == "mine":
		var mine = Area2D.new(); mine.position = pos
		var rect = ColorRect.new(); rect.color = Color.RED; rect.position = Vector2(-15, -5); rect.size = Vector2(30, 10); mine.add_child(rect)
		var coll = CollisionShape2D.new(); var shape = RectangleShape2D.new(); shape.size = Vector2(30, 10); coll.shape = shape; mine.add_child(coll)
		mine.body_entered.connect(func(body): 
			if body.has_method("rpc_take_damage") and body != self: 
				body.rpc_take_damage.rpc(body.max_hp * 0.5, name.to_int(), true); mine.queue_free()
		)
		get_tree().current_scene.add_child(mine)
	elif type == "dome_protect":
		var dome = Area2D.new(); dome.position = pos; dome.set_meta("hp", 200.0)
		var mesh_inst = MeshInstance2D.new(); var sphere = SphereMesh.new(); sphere.radius = 150; sphere.height = 300; mesh_inst.mesh = sphere
		mesh_inst.modulate = Color(0.2, 0.8, 1.0, 0.4); dome.add_child(mesh_inst)
		var coll = CollisionShape2D.new(); var shape = CircleShape2D.new(); shape.radius = 150; coll.shape = shape; dome.add_child(coll)
		dome.area_entered.connect(func(area):
			if area.is_in_group("bullets") and area.shooter != self:
				area.explode_or_die()
				var d_hp = dome.get_meta("hp") - area.damage
				if d_hp <= 0: dome.queue_free()
				else: dome.set_meta("hp", d_hp)
		)
		get_tree().current_scene.add_child(dome); get_tree().create_timer(10.0).timeout.connect(func(): if is_instance_valid(dome): dome.queue_free())
	elif type == "arena_dome":
		var dome = Area2D.new(); dome.position = pos; dome.add_to_group("arena_domes"); dome.set_meta("caster", name.to_int())
		var mesh_inst = MeshInstance2D.new(); var sphere = SphereMesh.new(); sphere.radius = 600; sphere.height = 1200; mesh_inst.mesh = sphere
		mesh_inst.modulate = Color(0.5, 0.0, 1.0, 0.2); dome.add_child(mesh_inst)
		get_tree().current_scene.add_child(dome); get_tree().create_timer(8.0).timeout.connect(func(): if is_instance_valid(dome): dome.queue_free())
	elif type == "smoke":
		var smoke = Area2D.new(); smoke.add_to_group("smokes"); smoke.position = pos
		var mesh = MeshInstance2D.new(); var sphere = SphereMesh.new(); sphere.radius = 250; sphere.height = 500; mesh.mesh = sphere
		mesh.modulate = Color(0.2, 0.2, 0.2, 0.9); smoke.add_child(mesh)
		get_tree().current_scene.add_child(smoke); get_tree().create_timer(5.0).timeout.connect(func(): if is_instance_valid(smoke): smoke.queue_free())
	elif type == "explosion":
		var boom = Node2D.new(); boom.position = pos
		var mesh = MeshInstance2D.new(); var sphere = SphereMesh.new(); sphere.radius = 150; sphere.height = 300; mesh.mesh = sphere
		mesh.modulate = Color(1, 0.4, 0, 0.6); boom.add_child(mesh); get_tree().current_scene.add_child(boom)
		var tw = create_tween(); tw.tween_property(mesh, "modulate:a", 0.0, 0.5)
		get_tree().create_timer(0.5).timeout.connect(func(): if is_instance_valid(boom): boom.queue_free())
	elif type == "dome_solid":
		for i in range(8):
			var angle = i * (PI / 4.0); var w_pos = pos + Vector2(cos(angle), sin(angle)) * 150
			rpc_spawn_object("ice", w_pos) 
	elif type == "decoy":
		var decoy = Sprite2D.new(); decoy.texture = sprite.texture; decoy.modulate = sprite.modulate; decoy.position = pos
		get_tree().current_scene.add_child(decoy)
		var tween = create_tween(); tween.tween_property(decoy, "position:x", pos.x + 800, 3.0)
		get_tree().create_timer(4.0).timeout.connect(func(): if is_instance_valid(decoy): decoy.queue_free())

func spawn_floating_text_local(text: String, color: Color):
	var label = Label.new(); label.text = text; label.modulate = color; label.global_position = global_position + Vector2(-20, -50)
	get_tree().current_scene.add_child(label)
	var tw = create_tween().set_parallel(true)
	tw.tween_property(label, "global_position:y", label.global_position.y - 100, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tw.tween_property(label, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tw.chain().tween_callback(label.queue_free)

func process_abilities(delta):
	if reflect_timer > 0:
		reflect_timer -= delta; if reflect_timer <= 0: is_reflecting = false
	if shrink_timer > 0:
		shrink_timer -= delta
		if shrink_timer <= 0:
			var scl = base_sprite_scale * BODY_STATS[current_body].scl
			sprite.scale = scl; collision_shape.scale = Vector2(scl.x, scl.y)
	if anchor_timer > 0:
		anchor_timer -= delta; if anchor_timer <= 0: is_anchored = false
	if rawwr_timer > 0: rawwr_timer -= delta
	if roll_timer > 0: roll_timer -= delta
	if invis_timer > 0:
		invis_timer -= delta; sprite.modulate.a = 0.0; gun_sprite.modulate.a = 0.0; hp_bar.modulate.a = 0.0; ammo_ui.modulate.a = 0.0
		if invis_timer <= 0: sprite.modulate.a = 1.0; gun_sprite.modulate.a = 1.0; hp_bar.modulate.a = 1.0; ammo_ui.modulate.a = 1.0

func process_body_passives(delta):
	if multiplayer.is_server() and (current_body == BodyType.FIRE_AURA or current_body == BodyType.LIFESTEAL_AURA):
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 300:
				p.rpc_take_damage.rpc(5 * delta, name.to_int())
				if current_body == BodyType.LIFESTEAL_AURA: rpc_apply_heal(5 * delta)
					
	if current_body == BodyType.PASSIVE_REGEN and hp < max_hp:
		regen_timer += delta; if regen_timer >= 1.0: rpc_apply_heal(5); regen_timer = 0.0
			
	if current_body == BodyType.CHANNELER and multiplayer.is_server():
		channeler_timer += delta
		if channeler_timer >= 3.0:
			channeler_timer = 0.0; var closest = null; var dist = 300.0
			for p in get_tree().get_nodes_in_group("players"):
				if p != self and not p.is_dead and global_position.distance_to(p.global_position) < dist: closest = p
			if closest: closest.rpc_take_damage.rpc(10, name.to_int())
			
	if current_body == BodyType.STEALTH and invis_timer <= 0:
		var target_a = 0.05 if velocity.length() < 10 else 1.0
		sprite.modulate.a = move_toward(sprite.modulate.a, target_a, delta * 2)
		gun_sprite.modulate.a = sprite.modulate.a; hp_bar.modulate.a = sprite.modulate.a; ammo_ui.modulate.a = sprite.modulate.a

	if current_body == BodyType.SCUM and multiplayer.is_server():
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and not p.is_dead and global_position.distance_to(p.global_position) < 150: p.rpc_apply_status.rpc("blind", Vector2.ZERO, 0.5)

@rpc("any_peer", "call_local", "unreliable")
func rpc_update_mouse(pos): sync_mouse_pos = pos

func shoot(charge: float = 0.0):
	can_shoot = false; invis_timer = 0.0 
	var stats = WEAPON_STATS[current_weapon]
	var fire_rate_mod = stats.fr
	if current_weapon == GunType.MINIGUN:
		minigun_heat = min(minigun_heat + 0.05, 1.0); fire_rate_mod = lerp(0.3, 0.02, minigun_heat)
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
	ammo -= 1; animate_recoil(charge); update_ammo_ui()
	
	if stats.kb > 0 and is_multiplayer_authority() and current_body != BodyType.HEAVY_WEIGHT and not is_anchored:
		velocity += Vector2.RIGHT.rotated(rot + PI) * stats.kb
		
	var hit_dist = 2000.0
	if stats.trait == Trait.BEAM:
		var space = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(pos, pos + Vector2.RIGHT.rotated(rot) * 2000)
		query.collision_mask = 0xFFFFFFFF; query.exclude = [self.get_rid()] 
		var result = space.intersect_ray(query)
		if result: hit_dist = pos.distance_to(result.position)
	
	if weapon_id == GunType.PLASMA_CANNON: pos += Vector2.RIGHT.rotated(rot) * 40.0
	
	var arena_buff = 1.0
	for d in get_tree().get_nodes_in_group("arena_domes"):
		if global_position.distance_to(d.global_position) < 600 and d.get_meta("caster") == name.to_int(): arena_buff = 1.25
	
	for i in range(stats.pel):
		var bullet = bullet_scene.instantiate(); bullet.shooter = self; bullet.global_position = pos
		var spread = stats.spr
		if weapon_id == GunType.CHARGE_GUN and charge < 1.0: spread *= 2.0
		bullet.rotation = rot + randf_range(-spread, spread)
		bullet.speed = stats.spd
		bullet.damage = (stats.dmg + (charge / 5.0) * 84.0) * arena_buff
		if weapon_id == GunType.TDE_BEAM: bullet.damage *= pow(1.5, tde_bonus) 
		if rawwr_timer > 0: bullet.damage *= 1.5 
		
		bullet.scale = Vector2(1.0, 1.0)
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
	var stats = WEAPON_STATS[current_weapon]; minigun_heat = 0.0
	if stats.rl_type == 1:
		ammo += 1; update_ammo_ui()
		if ammo < max_ammo: reload_timer.start()
	else: ammo = max_ammo; update_ammo_ui()

func update_ammo_ui():
	for i in range(ammo_ui.get_child_count()): ammo_ui.get_child(i).modulate.a = 1.0 if i < ammo else 0.2 

func handle_status_effects(delta):
	var in_smoke = false
	for s in get_tree().get_nodes_in_group("smokes"):
		if global_position.distance_to(s.global_position) < 250: in_smoke = true
	if in_smoke: status_blind_timer = 0.5
	
	if poison_timer > 0:
		poison_timer -= delta; poison_tick -= delta
		if poison_tick <= 0:
			poison_tick = 0.5; hp -= 2; var tw = create_tween(); sprite.modulate = Color.GREEN; tw.tween_property(sprite, "modulate", original_color, 0.2); if hp <= 0: die()
			
	if status_tractor_timer > 0: status_tractor_timer -= delta
	
	if status_blind_timer > 0: status_blind_timer -= delta; sprite.modulate = Color.BLACK
	elif status_stasis_timer > 0: status_stasis_timer -= delta; sprite.modulate = Color.BLUE
	elif status_pin_timer > 0: status_pin_timer -= delta; sprite.modulate = Color.WEB_GRAY 
	elif status_slow_timer > 0: status_slow_timer -= delta; current_speed = BASE_SPEED * 0.75; sprite.modulate = Color.CYAN 
	else: current_speed = BASE_SPEED; sprite.modulate = original_color

@rpc("any_peer", "call_local", "reliable")
func rpc_apply_status(type, dir = Vector2.ZERO, duration = 1.0, caster_id = -1):
	if type == "slow": status_slow_timer = 2.0
	elif type == "nail" and not is_anchored: nail_knockback_velocity = dir * 2500
	elif type == "pin": status_pin_timer = 2.0
	elif type == "blind": status_blind_timer = duration
	elif type == "stasis": status_stasis_timer = 3.0; stasis_caster = caster_id
	elif type == "poison" and poison_timer <= 0: poison_timer = 3.0; poison_tick = 0.5
	elif type == "tractor": status_tractor_timer = 0.5

@rpc("any_peer", "call_local", "reliable")
func rpc_pull(target_pos, force):
	if not is_multiplayer_authority() or is_anchored: return
	var dir = (target_pos - global_position).normalized()
	velocity = dir * force 

@rpc("any_peer", "call_local", "reliable")
func rpc_take_damage(amount, attacker_id = -1, is_explosion = false):
	if not multiplayer.is_server(): return 
	if is_dead or roll_timer > 0 or is_anchored: return 
	if status_stasis_timer > 0 and attacker_id == stasis_caster: return 
	if current_body == BodyType.INVINCIBLE and time_since_spawn < 5.0: return

	var dodged = false
	var blinked = false
	var tp_pos = Vector2.ZERO
	var final_amount = amount

	if current_body == BodyType.BOMBER and is_explosion and attacker_id != name.to_int(): final_amount *= 0.5
	if current_body == BodyType.BOMBER and attacker_id == name.to_int(): return
	if current_body == BodyType.GAMBLER and randf() < 0.25: final_amount *= 0.5; dodged = true
	if current_body == BodyType.LAST_STAND and hp <= max_hp * 0.25: final_amount *= 0.5
	
	if temp_hp > 0:
		temp_hp -= final_amount
		if temp_hp < 0: final_amount = abs(temp_hp); temp_hp = 0
		else: 
			rpc_sync_damage_result.rpc(hp, temp_hp, 0, attacker_id, false, false, Vector2.ZERO)
			return 
	
	if current_body == BodyType.TURTLE and attacker_id != -1:
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker:
			var dir_to_attacker = sign(attacker.global_position.x - global_position.x)
			var facing_dir = sign(sync_mouse_pos.x - global_position.x)
			if dir_to_attacker != facing_dir: final_amount *= 0.5 
			
	if current_body == BodyType.UNSTABLE and randf() < 0.15:
		var space = get_world_2d().direct_space_state
		tp_pos = global_position + Vector2(randf_range(-200, 200), randf_range(-200, -50))
		var query = PhysicsRayQueryParameters2D.create(global_position, tp_pos); var res = space.intersect_ray(query)
		if res: tp_pos = res.position - (tp_pos - global_position).normalized() * 30
		final_amount = 0; blinked = true
	
	hp -= final_amount
	
	if current_body == BodyType.REACTIVE_ARMOR and hp < max_hp * 0.5 and not reactive_triggered:
		reactive_triggered = true
		for p in get_tree().get_nodes_in_group("players"):
			if p != self and global_position.distance_to(p.global_position) < 200: p.rpc_pull.rpc(global_position, -2500) 
	if current_body == BodyType.REACTIVE_ARMOR and hp >= max_hp * 0.5: reactive_triggered = false
				
	if current_body == BodyType.THORNS and attacker_id != -1 and attacker_id != name.to_int():
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker: attacker.rpc_take_damage.rpc(final_amount * 0.2, name.to_int())
		
	if current_body == BodyType.COLD_BLOOD and attacker_id != -1:
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker: attacker.rpc_apply_status.rpc("slow")

	if hp <= 0 and attacker_id != -1:
		var attacker = get_parent().get_node_or_null(str(attacker_id))
		if attacker and attacker.current_body == BodyType.VAMPIRE_BODY: attacker.rpc_apply_heal.rpc(30)
		
	rpc_sync_damage_result.rpc(hp, temp_hp, final_amount, attacker_id, dodged, blinked, tp_pos)

@rpc("any_peer", "call_local", "reliable")
func rpc_sync_damage_result(server_hp, server_temp_hp, amount_taken, _attacker_id, dodged, blinked, tp_pos):
	hp = server_hp
	temp_hp = server_temp_hp
	invis_timer = 0.0

	if dodged:
		var tw = create_tween(); sprite.modulate = Color.BLUE; tw.tween_property(sprite, "modulate", original_color, 0.3)
		spawn_floating_text_local("Dodged!", Color.BLUE)
	elif blinked:
		global_position = tp_pos
		spawn_floating_text_local("Blink!", Color.PURPLE)

	if amount_taken > 0:
		var tween = create_tween()
		sprite.modulate = Color.RED
		tween.tween_property(sprite, "modulate", original_color, 0.2) 

	if hp <= 0 and not is_dead:
		die()

func die():
	is_dead = true; hide(); hp_bar.hide(); ammo_ui.hide(); collision_shape.set_deferred("disabled", true) 
	if is_instance_valid(active_grapple): active_grapple.rpc("destroy_bullet")
	
	if GameManager.current_game_mode == "creative":
		get_tree().create_timer(3.0).timeout.connect(respawn)
	else:
		if multiplayer.is_server():
			var arenas = get_tree().get_nodes_in_group("arena_manager")
			if arenas.size() > 0: arenas[0].check_round_end()

func respawn():
	global_position = spawn_position; hp = max_hp; ammo = max_ammo; is_dead = false
	status_pin_timer = 0; status_slow_timer = 0; status_blind_timer = 0; poison_timer = 0.0; time_since_spawn = 0.0; reactive_triggered = false
	nail_knockback_velocity = Vector2.ZERO; collision_shape.set_deferred("disabled", false) 
	update_ammo_ui(); hp_bar.show(); ammo_ui.show(); show()
