extends Node

var players = {}

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id):
	if multiplayer.is_server():
		players[id] = { "weapon": 0, "ready": false }
		sync_to_clients()

func _on_peer_disconnected(id):
	if multiplayer.is_server():
		players.erase(id)
		sync_to_clients()

func sync_to_clients():
	rpc_update_players.rpc(players)

@rpc("authority", "call_local", "reliable")
func rpc_update_players(server_players):
	players = server_players
