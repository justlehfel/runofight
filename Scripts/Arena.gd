extends Node2D

var player_scene = preload("res://Scenes/Player.tscn")

func _ready():
	if multiplayer.is_server():
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		await get_tree().create_timer(0.5).timeout
		spawn_players()

func _on_peer_disconnected(id):
	var p = $Players.get_node_or_null(str(id))
	if p: p.queue_free()

func spawn_players():
	var spawn_index = 0
	for peer_id in GameManager.players:
		add_player(peer_id, spawn_index)
		spawn_index += 1

func add_player(peer_id, index):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	
	player.current_weapon = GameManager.players[peer_id]["weapon"]
	player.current_body = GameManager.players[peer_id]["body"]
	player.current_ability = GameManager.players[peer_id]["ability"] 
	
	var spawn_points = [
		Vector2(200, 200),
		Vector2(800, 200),
		Vector2(200, 600),
		Vector2(800, 600)
	]
	
	player.position = spawn_points[index % spawn_points.size()]
		
	$Players.add_child(player, true)
