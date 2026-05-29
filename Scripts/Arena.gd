extends Node2D
var player_scene = preload("res://Scenes/Player.tscn")

func _ready():
	if multiplayer.is_server():
		call_deferred("spawn_players")

func spawn_players():
	var spawn_index = 0
	for peer_id in GameManager.players:
		add_player(peer_id, spawn_index)
		spawn_index += 1

func add_player(peer_id, index):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	
	if index == 0:
		player.position = Vector2(200, 200)
	else:
		player.position = Vector2(800, 200)
		
	$Players.add_child(player, true)
