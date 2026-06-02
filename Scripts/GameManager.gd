extends Node

signal players_updated

var players = {}
var current_game_mode = "creative"
var match_active = true

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().current_scene.name == "MainMenu": return 
		if multiplayer.multiplayer_peer != null: rpc_quit_to_menu.rpc()
		else: reset_and_go_to_menu()

func _on_peer_connected(id):
	if multiplayer.is_server():
		players[id] = {
			"name": "Runer " + str(players.size() + 1),
			"color": Color(randf(), randf(), randf(), 1.0).to_html(), 
			"lobby_ready": false,
			"weapon": 0, "body": 0, "ability": 0, "ready": false
		}
		sync_to_clients()

func _on_peer_disconnected(id):
	if multiplayer.is_server():
		players.erase(id)
		sync_to_clients()
		rpc_quit_to_menu.rpc()

func _on_server_disconnected():
	reset_and_go_to_menu()

func sync_to_clients():
	rpc_update_players.rpc(players)

@rpc("authority", "call_local", "reliable")
func rpc_update_players(server_players):
	players = server_players
	players_updated.emit() 

@rpc("any_peer", "call_local", "reliable")
func rpc_quit_to_menu():
	reset_and_go_to_menu()

func reset_and_go_to_menu():
	players.clear()
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	call_deferred("_change_scene_to_menu")

func _change_scene_to_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
