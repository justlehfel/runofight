extends Control

# --- CONSTANTES ET RÉFÉRENCES UI ---
# Chargement du script principal du joueur et liaisons avec les menus déroulants
const PlayerScript = preload("res://Scripts/player.gd")

@onready var weapon_list = $WeaponList
@onready var body_list = $BodyList
@onready var ability_list = $AbilityList
@onready var btn_confirm = $BtnConfirm
@onready var wait_label = $WaitLabel

# --- INITIALISATION ---
# Remplissage automatique des listes déroulantes basées sur les énumérations du joueur
func _ready():
	for weapon_name in PlayerScript.GunType.keys(): weapon_list.add_item(weapon_name)
	for body_name in PlayerScript.BodyType.keys(): body_list.add_item(body_name)
	for ability_name in PlayerScript.AbilityType.keys(): ability_list.add_item(ability_name) 
		
	btn_confirm.pressed.connect(_on_confirm_pressed)

# --- GESTION DE L'INTERFACE EN TEMPS RÉEL ---
# Active ou désactive les sélections selon le statut "Prêt" et le nombre de joueurs connectés
func _process(_delta):
	var connected = GameManager.players.size()
	var is_solo = (GameManager.current_game_mode == "solo")
	
	if connected < 2 and not is_solo:
		wait_label.text = "Waiting for other players..."
		wait_label.show()
		btn_confirm.disabled = true
		weapon_list.disabled = true
		body_list.disabled = true
		ability_list.disabled = true
	else:
		var my_id = 1 if is_solo else multiplayer.get_unique_id()
		var i_am_ready = GameManager.players.has(my_id) and GameManager.players[my_id]["ready"]
		
		var all_others_ready = true
		for id in GameManager.players:
			if id != my_id and not GameManager.players[id]["ready"]: 
				all_others_ready = false
				
		if not i_am_ready:
			btn_confirm.disabled = false
			weapon_list.disabled = false
			body_list.disabled = false
			ability_list.disabled = false
			wait_label.text = "Others are ready ! Your turn..." if all_others_ready and not is_solo else "Make your choice."
			wait_label.show()
		else:
			wait_label.text = "Starting..." if all_others_ready else "Waiting for other players..."
			wait_label.show()

# --- VALIDATION DES CHOIX ---
# Verrouille l'interface et enregistre la sélection localement (en solo) ou l'envoie au serveur
func _on_confirm_pressed():
	btn_confirm.disabled = true
	weapon_list.disabled = true
	body_list.disabled = true
	ability_list.disabled = true
	
	if GameManager.current_game_mode == "solo":
		GameManager.players[1]["weapon"] = weapon_list.selected
		GameManager.players[1]["body"] = body_list.selected
		GameManager.players[1]["ability"] = ability_list.selected
		GameManager.players[1]["ready"] = true
		check_all_ready()
	else:
		var my_id = multiplayer.get_unique_id()
		rpc_set_ready.rpc_id(1, my_id, weapon_list.selected, body_list.selected, ability_list.selected)

# --- SYNCHRONISATION RÉSEAU ---
# Mise à jour des équipements d'un joueur côté serveur et synchronisation avec les autres clients
@rpc("any_peer", "call_local", "reliable")
func rpc_set_ready(peer_id, weapon_id, body_id, ability_id):
	if multiplayer.is_server():
		GameManager.players[peer_id]["weapon"] = weapon_id
		GameManager.players[peer_id]["body"] = body_id
		GameManager.players[peer_id]["ability"] = ability_id 
		GameManager.players[peer_id]["ready"] = true
		GameManager.sync_to_clients()
		check_all_ready()

# --- LANCEMENT DE LA PARTIE ---
# Vérifie si tous les participants ont validé leurs choix avant de lancer l'arène
func check_all_ready():
	var is_solo = (GameManager.current_game_mode == "solo")
	
	if GameManager.players.size() < 2 and not is_solo: return 
	
	for id in GameManager.players:
		if not GameManager.players[id]["ready"]: return
		
	if is_solo:
		get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
	else:
		rpc_start_arena.rpc()

@rpc("authority", "call_local", "reliable")
func rpc_start_arena():
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
