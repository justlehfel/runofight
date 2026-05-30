extends Control

const PlayerScript = preload("res://Scripts/player.gd")

@onready var weapon_list = $WeaponList
@onready var btn_confirm = $BtnConfirm
@onready var wait_label = $WaitLabel

func _ready():
	for weapon_name in PlayerScript.GunType.keys():
		weapon_list.add_item(weapon_name)
	btn_confirm.pressed.connect(_on_confirm_pressed)

func _process(_delta):
	var connected = GameManager.players.size()
	if connected < 2:
		wait_label.text = "En attente d'un adversaire..."
		wait_label.show()
		btn_confirm.disabled = true
		weapon_list.disabled = true
	else:
		var my_id = multiplayer.get_unique_id()
		var i_am_ready = GameManager.players.has(my_id) and GameManager.players[my_id]["ready"]
		
		var other_ready = false
		for id in GameManager.players:
			if id != my_id and GameManager.players[id]["ready"]:
				other_ready = true
				
		if not i_am_ready:
			btn_confirm.disabled = false
			weapon_list.disabled = false
			if other_ready:
				wait_label.text = "L'adversaire est prêt ! À vous de choisir."
			else:
				wait_label.text = "Adversaire connecté. Faites votre choix."
			wait_label.show()
		else:
			if other_ready:
				wait_label.text = "Lancement de la partie..."
			else:
				wait_label.text = "En attente que l'adversaire choisisse..."
			wait_label.show()

func _on_confirm_pressed():
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
	if GameManager.players.size() < 2: return 
	var all_ready = true
	for id in GameManager.players:
		if not GameManager.players[id]["ready"]:
			all_ready = false
	if all_ready:
		rpc_start_arena.rpc()

@rpc("authority", "call_local", "reliable")
func rpc_start_arena():
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
