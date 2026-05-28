extends Node2D

var player_scene = preload("res://Scenes/Player.tscn")

func _ready():
	if multiplayer.is_server():
		add_player(multiplayer.get_unique_id())
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_disconnected.connect(remove_player)

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id) 
	player.position = Vector2(0, -200) 
	$Players.add_child(player, true) 

func remove_player(peer_id):
	var player = $Players.get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
