extends Control

const PORT = 8910

@onready var ip_input = $VBoxContainer/IpInput
@onready var btn_host = $VBoxContainer/BtnHost
@onready var btn_join = $VBoxContainer/BtnJoin
@onready var btn_quitter = $VBoxContainer/BtnQuit

func _ready():
	btn_host.pressed.connect(_on_host_pressed)
	btn_join.pressed.connect(_on_join_pressed)
	btn_quitter.pressed.connect(func(): get_tree().quit())

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		start_game()

func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	var ip = ip_input.text
	if ip == "": 
		ip = "127.0.0.1"
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
