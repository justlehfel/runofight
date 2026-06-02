extends Node2D

var player_scene = preload("res://Scenes/Player.tscn")

func _ready():
	if multiplayer.is_server():
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		await get_tree().create_timer(1.0).timeout
		spawn_players()

func _on_peer_disconnected(id):
	var p = $Players.get_node_or_null(str(id))
	if p: p.queue_free()

func spawn_players():
	for peer_id in GameManager.players:
		var player = player_scene.instantiate()
		player.name = str(peer_id)
		$Players.add_child(player, true)
