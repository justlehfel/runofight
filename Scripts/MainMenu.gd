extends Control

# --- PARAMÈTRES ET RÉFÉRENCES UI ---
# Définition du port réseau, état de la connexion et liaisons avec les éléments des menus
const PORT = 8910

var pending_connection = "" 

@onready var play_submenu = $PlaySubMenu
@onready var btn_solo = $PlaySubMenu/BtnSolo
@onready var btn_multi_regular = $PlaySubMenu/BtnMultiRegular
@onready var btn_multi_creative = $PlaySubMenu/BtnMultiCreative
@onready var btn_back = $PlaySubMenu/BtnBack

@onready var network_menu = $NetworkMenu
@onready var ip_input = $NetworkMenu/IpInput
@onready var btn_host = $NetworkMenu/BtnHost
@onready var btn_join = $NetworkMenu/BtnJoin
@onready var btn_quit = $NetworkMenu/BtnQuit

# --- INITIALISATION ---
# Configuration de la visibilité des menus au lancement et assignation des événements de clics
func _ready():
	network_menu.show()
	play_submenu.hide()

	btn_host.pressed.connect(_on_host_pressed)
	btn_join.pressed.connect(_on_join_pressed)
	btn_quit.pressed.connect(func(): get_tree().quit())

	btn_solo.pressed.connect(_on_solo_pressed)
	btn_multi_regular.pressed.connect(_on_multi_regular_pressed)
	btn_multi_creative.pressed.connect(_on_multi_creative_pressed)
	btn_back.pressed.connect(_on_back_pressed)

# --- NAVIGATION DES MENUS ---
# Bascule l'affichage entre l'écran réseau principal et le sous-menu de sélection de mode
func _on_host_pressed():
	pending_connection = "host"
	network_menu.hide()
	play_submenu.show()

func _on_join_pressed():
	pending_connection = "join"
	network_menu.hide()
	play_submenu.show()

func _on_back_pressed():
	pending_connection = ""
	play_submenu.hide()
	network_menu.show()

# --- SÉLECTION DU MODE DE JEU ---
# Application du mode choisi (Solo, Compétitif ou Créatif) et transition vers la scène appropriée
func _on_solo_pressed():
	pending_connection = ""
	GameManager.current_game_mode = "solo"
	GameManager.players.clear()
	GameManager.players[1] = { 
		"name": "Solo Runer", 
		"color": Color.CYAN.to_html(), 
		"lobby_ready": true, 
		"weapon": 0, "body": 0, "ability": 0, "ready": false 
	}
	get_tree().change_scene_to_file("res://Scenes/RuneTree.tscn")

func _on_multi_regular_pressed():
	GameManager.current_game_mode = "regular"
	if connect_to_network():
		get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")

func _on_multi_creative_pressed():
	GameManager.current_game_mode = "creative"
	if connect_to_network():
		get_tree().change_scene_to_file("res://Scenes/RuneTree.tscn")

# --- GESTION DU RÉSEAU (MULTIJOUEUR) ---
# Logique de création du serveur (Host) ou de la connexion à un hôte distant (Client)
func connect_to_network() -> bool:
	if pending_connection == "host":
		return start_server()
	elif pending_connection == "join":
		return start_client()
	return false

func start_server() -> bool:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		GameManager.players.clear()
		GameManager.players[1] = { 
			"name": "Host Runer", 
			"color": Color(0.2, 0.8, 1.0, 1.0).to_html(), 
			"lobby_ready": false, 
			"weapon": 0, "body": 0, "ability": 0, "ready": false 
		}
		return true
	else:
		print("Error creation of server ", error)
		return false

func start_client() -> bool:
	var peer = ENetMultiplayerPeer.new()
	var ip = ip_input.text
	if ip == "": ip = "127.0.0.1"
	
	var error = peer.create_client(ip, PORT)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		GameManager.players[multiplayer.get_unique_id()] = { 
			"name": "Joining...", 
			"color": Color.WHITE.to_html(), 
			"lobby_ready": false, 
			"weapon": 0, "body": 0, "ability": 0, "ready": false 
		}
		return true
	else:
		print("Impossible to join host : ", error)
		return false
