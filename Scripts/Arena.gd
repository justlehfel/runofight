extends Node2D

@onready var players_node = $Players
@onready var score_ui = $ScoreUI 
@onready var cinematic_layer = $CinematicLayer
@onready var cinematic_label = $CinematicLayer/Label
@onready var cinematic_bg = $CinematicLayer/ColorRect

var player_scores = {}
var round_number = 1

func _ready():
	add_to_group("arena_manager")
	cinematic_layer.hide()
	GameManager.match_active = false

	for id in GameManager.players: player_scores[id] = 0
	spawn_players()

	if GameManager.current_game_mode == "regular":
		update_score_ui()
		start_round_cinematic()
	else:
		GameManager.match_active = true 

func spawn_players():
	for child in players_node.get_children():
		child.name += "_deleted"
		child.queue_free()

	var player_scene = preload("res://Scenes/Player.tscn") 
	for peer_id in GameManager.players:
		var player = player_scene.instantiate()
		player.name = str(peer_id)
		players_node.add_child(player, true)

	if GameManager.current_game_mode == "solo":
		var dummy = player_scene.instantiate()
		dummy.name = "999"; dummy.is_dummy = true
		dummy.global_position = Vector2(1500, 50)
		players_node.add_child(dummy, true)

@rpc("authority", "call_local", "reliable")
func rpc_play_cinematic(text, duration):
	cinematic_label.text = text
	cinematic_layer.show()
	cinematic_bg.modulate.a = 0; cinematic_label.modulate.a = 0

	var tw = create_tween().set_parallel(true)
	tw.tween_property(cinematic_bg, "modulate:a", 0.8, 0.3)
	tw.tween_property(cinematic_label, "modulate:a", 1.0, 0.3)

	get_tree().create_timer(duration).timeout.connect(func():
		var tw2 = create_tween().set_parallel(true)
		tw2.tween_property(cinematic_bg, "modulate:a", 0.0, 0.3)
		tw2.tween_property(cinematic_label, "modulate:a", 0.0, 0.3)
		tw2.chain().tween_callback(cinematic_layer.hide)
	)

func start_round_cinematic():
	if not multiplayer.is_server(): return
	GameManager.match_active = false
	rpc_play_cinematic.rpc("Round " + str(round_number) + "\nFIGHT!", 2.0)
	
	get_tree().create_timer(2.0).timeout.connect(func():
		rpc_set_match_active.rpc(true)
	)

@rpc("authority", "call_local", "reliable")
func rpc_set_match_active(active):
	GameManager.match_active = active

func check_round_end():
	if not multiplayer.is_server() or not GameManager.match_active: return

	var alive_players = []
	for p in players_node.get_children():
		if not p.is_dead and not p.is_dummy: alive_players.append(p)

	if GameManager.current_game_mode == "solo": return

	if alive_players.size() <= 1:
		rpc_set_match_active.rpc(false) 
		var winner_id = -1
		var winner_name = "Égalité"

		if alive_players.size() == 1:
			winner_id = alive_players[0].name.to_int()
			winner_name = GameManager.players[winner_id]["name"]
			player_scores[winner_id] += 1
			rpc_update_scores.rpc(player_scores)

		var match_over = (winner_id != -1 and player_scores[winner_id] >= 5)

		if match_over:
			rpc_play_cinematic.rpc(winner_name + " GAGNE LA PARTIE !", 4.0)
			get_tree().create_timer(4.0).timeout.connect(func(): GameManager.rpc_quit_to_menu.rpc())
		else:
			if winner_id == -1: rpc_play_cinematic.rpc("Égalité !\nPersonne ne gagne ce round.", 3.0)
			else: rpc_play_cinematic.rpc(winner_name + " gagne le round !", 3.0)

			get_tree().create_timer(3.0).timeout.connect(func():
				round_number += 1
				rpc_reset_arena.rpc()
				start_round_cinematic()
			)

@rpc("authority", "call_local", "reliable")
func rpc_update_scores(new_scores):
	player_scores = new_scores
	update_score_ui()

@rpc("authority", "call_local", "reliable")
func rpc_reset_arena():
	for p in players_node.get_children(): p.respawn()

func update_score_ui():
	if score_ui:
		for child in score_ui.get_children(): child.queue_free()
		for id in player_scores:
			if GameManager.players.has(id):
				var p_data = GameManager.players[id]
				var lbl = Label.new()
				lbl.text = p_data["name"] + ": " + str(player_scores[id]) + "   "
				lbl.modulate = Color(p_data["color"])
				lbl.add_theme_font_size_override("font_size", 28)
				lbl.add_theme_color_override("font_outline_color", Color.BLACK)
				lbl.add_theme_constant_override("outline_size", 4)
				score_ui.add_child(lbl)
