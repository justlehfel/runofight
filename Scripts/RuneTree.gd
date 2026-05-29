extends Control

const PlayerScript = preload("res://Scripts/player.gd")

@onready var weapon_list = $WeaponList
@onready var btn_confirm = $BtnConfirm
@onready var wait_label = $WaitLabel

func _ready():
	wait_label.hide() 
	
	for weapon_name in PlayerScript.GunType.keys():
		weapon_list.add_item(weapon_name)
		
	btn_confirm.pressed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	btn_confirm.disabled = true
	weapon_list.disabled = true
	wait_label.show()
	
	var my_id = multiplayer.get_unique_id()
	var chosen_weapon = weapon_list.selected
	
	rpc_set_ready.rpc_id(1, my_id, chosen_weapon)

@rpc("any_peer", "call_local", "reliable")
func rpc_set_ready(peer_id, weapon_id):
	if multiplayer.is_server():
		GameManager.players[peer_id]["weapon"] = weapon_id
		GameManager.players[peer_id]["ready"] = true
		GameManager.sync_to_clients() 
		
		check_all_ready()

func check_all_ready():
	if GameManager.players.size() < 2:
		return 
		
	var all_ready = true
	for id in GameManager.players:
		if not GameManager.players[id]["ready"]:
			all_ready = false
			
	if all_ready:
		rpc_start_arena.rpc()

@rpc("authority", "call_local", "reliable")
func rpc_start_arena():
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
