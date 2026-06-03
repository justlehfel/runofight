extends Control

# --- VARIABLES DE L'INTERFACE ET D'ÉTAT ---
# Références aux éléments graphiques et suivi du temps pour les animations
var player_list_vbox: VBoxContainer
var chat_display: RichTextLabel
var chat_input: LineEdit
var name_input: LineEdit
var color_picker: ColorPickerButton
var btn_ready: Button
var count_label: Label

var time_passed = 0.0

# --- INITIALISATION ET BOUCLE VISUELLE ---
# Connexion des signaux, création de l'interface et dessin de l'arrière-plan animé
func _ready():
	GameManager.players_updated.connect(_refresh_ui)
	_build_procedural_ui()
	_refresh_ui()
	
	_add_chat_message("Système", "FFFFFF", "Welcome to the Lobby !")

func _process(delta):
	time_passed += delta
	queue_redraw()

func _draw():
	draw_rect(Rect2(0, 0, 1920, 1080), Color(0.05, 0.05, 0.08))
	for i in range(20):
		var x = fmod((i * 200 + time_passed * 50 * (i%3 + 1)), 1920.0)
		var y = 1080.0 / 2.0 + sin(time_passed * 2.0 + i) * 300.0
		draw_circle(Vector2(x, y), 5.0 + (i%5)*2, Color(1, 1, 1, 0.05))

# --- CONSTRUCTION DE L'INTERFACE UTILISATEUR ---
# Génération procédurale de tous les éléments du lobby (titre, listes, chat, boutons)
# Bien que Duval ne sera pas enivré par cela, c'est nécessaire car plus configurable qu'avec l'éditeur 2D
func _build_procedural_ui():
	var margin = MarginContainer.new()
	margin.set_anchors_preset(PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 100)
	margin.add_theme_constant_override("margin_right", 100)
	margin.add_theme_constant_override("margin_top", 100)
	margin.add_theme_constant_override("margin_bottom", 100)
	add_child(margin)
	
	var main_hbox = HBoxContainer.new()
	main_hbox.add_theme_constant_override("separation", 100)
	margin.add_child(main_hbox)
	
	var left_vbox = VBoxContainer.new()
	left_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_vbox.size_flags_stretch_ratio = 1.0
	main_hbox.add_child(left_vbox)
	
	var title = Label.new()
	title.text = "Rune-O-Fight - Lobby"
	title.add_theme_font_size_override("font_size", 48)
	left_vbox.add_child(title)
	
	count_label = Label.new()
	count_label.add_theme_font_size_override("font_size", 24)
	left_vbox.add_child(count_label)
	
	player_list_vbox = VBoxContainer.new()
	player_list_vbox.add_theme_constant_override("separation", 20)
	left_vbox.add_child(player_list_vbox)
	
	var right_vbox = VBoxContainer.new()
	right_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_vbox.size_flags_stretch_ratio = 1.0
	main_hbox.add_child(right_vbox)
	
	var custom_label = Label.new()
	custom_label.text = "Personnalisation"
	custom_label.add_theme_font_size_override("font_size", 32)
	right_vbox.add_child(custom_label)
	
	var custom_hbox = HBoxContainer.new()
	name_input = LineEdit.new()
	name_input.placeholder_text = "Your name"
	name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_input.text_changed.connect(_on_profile_changed)
	custom_hbox.add_child(name_input)
	
	color_picker = ColorPickerButton.new()
	color_picker.custom_minimum_size = Vector2(50, 50)
	color_picker.color_changed.connect(_on_color_changed)
	custom_hbox.add_child(color_picker)
	right_vbox.add_child(custom_hbox)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 50)
	right_vbox.add_child(spacer)
	
	var chat_label = Label.new()
	chat_label.text = "Group Chat"
	chat_label.add_theme_font_size_override("font_size", 32)
	right_vbox.add_child(chat_label)
	
	var chat_bg = ColorRect.new()
	chat_bg.color = Color(0, 0, 0, 0.5)
	chat_bg.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_child(chat_bg)
	
	chat_display = RichTextLabel.new()
	chat_display.bbcode_enabled = true
	chat_display.set_anchors_preset(PRESET_FULL_RECT)
	chat_bg.add_child(chat_display)
	
	chat_input = LineEdit.new()
	chat_input.placeholder_text = "Write a message... (Enter to send)"
	chat_input.text_submitted.connect(_on_chat_submitted)
	right_vbox.add_child(chat_input)
	
	btn_ready = Button.new()
	btn_ready.text = "READY !"
	btn_ready.custom_minimum_size = Vector2(0, 80)
	btn_ready.add_theme_font_size_override("font_size", 32)
	btn_ready.pressed.connect(_on_ready_pressed)
	right_vbox.add_child(btn_ready)
	
	var is_solo = (GameManager.current_game_mode == "solo")
	var my_id = 1 if is_solo else multiplayer.get_unique_id()
	
	if GameManager.players.has(my_id):
		name_input.text = GameManager.players[my_id]["name"]
		color_picker.color = Color(GameManager.players[my_id]["color"])

# --- MISE À JOUR VISUELLE DES JOUEURS ---
# Actualise la liste des joueurs connectés, leurs couleurs et leur statut (Prêt ou En attente)
func _refresh_ui():
	count_label.text = "Players: " + str(GameManager.players.size()) + "/4"
	
	for child in player_list_vbox.get_children():
		child.queue_free()
		
	for id in GameManager.players:
		var p_data = GameManager.players[id]
		var panel = ColorRect.new()
		panel.color = Color(0.1, 0.1, 0.1, 0.8)
		panel.custom_minimum_size = Vector2(0, 60)
		
		var hbox = HBoxContainer.new()
		hbox.set_anchors_preset(PRESET_FULL_RECT)
		panel.add_child(hbox)
		
		var color_box = ColorRect.new()
		color_box.color = Color(p_data["color"])
		color_box.custom_minimum_size = Vector2(60, 60)
		hbox.add_child(color_box)
		
		var name_lbl = Label.new()
		name_lbl.text = "  " + p_data["name"]
		name_lbl.add_theme_font_size_override("font_size", 24)
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(name_lbl)
		
		var status_lbl = Label.new()
		if p_data["lobby_ready"]:
			status_lbl.text = "READY  "
			status_lbl.modulate = Color.GREEN
		else:
			status_lbl.text = "Waiting...  "
			status_lbl.modulate = Color.GRAY
		status_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(status_lbl)
		
		player_list_vbox.add_child(panel)

# --- PERSONNALISATION ET SYNCHRONISATION DU PROFIL ---
# Gère les changements de nom, de couleur, et le clic sur le bouton Prêt
func _on_profile_changed(_new_text): _sync_local_profile()
func _on_color_changed(_new_color): _sync_local_profile()

func _sync_local_profile():
	var is_solo = (GameManager.current_game_mode == "solo")
	var my_id = 1 if is_solo else multiplayer.get_unique_id()
	
	var c_name = name_input.text
	if c_name == "": c_name = "Anonymous"
	var c_hex = color_picker.color.to_html()
	var is_ready = GameManager.players[my_id]["lobby_ready"]
	
	if is_solo:
		GameManager.players[my_id]["name"] = c_name
		GameManager.players[my_id]["color"] = c_hex
		GameManager.players[my_id]["lobby_ready"] = is_ready
		_refresh_ui()
		check_launch_conditions()
	else:
		rpc_update_profile.rpc_id(1, my_id, c_name, c_hex, is_ready)

func _on_ready_pressed():
	var is_solo = (GameManager.current_game_mode == "solo")
	var my_id = 1 if is_solo else multiplayer.get_unique_id()
	
	var current_status = GameManager.players[my_id]["lobby_ready"]
	GameManager.players[my_id]["lobby_ready"] = not current_status
	btn_ready.text = "CANCEL" if not current_status else "READY !"
	btn_ready.modulate = Color.GREEN if not current_status else Color.WHITE
	
	_sync_local_profile()

# --- CONDITIONS DE LANCEMENT ET RÉSEAU ---
# Valide la présence des joueurs, vérifie si tous sont prêts et gère la transition vers le jeu
@rpc("any_peer", "call_local", "reliable")
func rpc_update_profile(peer_id, p_name, p_color_hex, is_ready):
	if multiplayer.multiplayer_peer != null and multiplayer.is_server():
		GameManager.players[peer_id]["name"] = p_name
		GameManager.players[peer_id]["color"] = p_color_hex
		GameManager.players[peer_id]["lobby_ready"] = is_ready
		GameManager.sync_to_clients()
		check_launch_conditions()

func check_launch_conditions():
	var all_ready = true
	for id in GameManager.players:
		if not GameManager.players[id]["lobby_ready"]: all_ready = false
	
	if all_ready and GameManager.players.size() >= 1:
		var is_solo = (GameManager.current_game_mode == "solo")
		if is_solo:
			get_tree().change_scene_to_file("res://Scenes/RuneTree.tscn")
		else:
			rpc_launch_cinematic.rpc()

@rpc("authority", "call_local", "reliable")
func rpc_launch_cinematic():
	if GameManager.current_game_mode == "regular":
		get_tree().change_scene_to_file("res://Scenes/CinematicChoice.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/RuneTree.tscn")

# --- SYSTÈME DE CHAT TEXTUEL ---
# Envoi, réception et formatage des messages dans la zone de chat du lobby
func _on_chat_submitted(new_text):
	if new_text.strip_edges() == "": return
	chat_input.text = ""
	
	var is_solo = (GameManager.current_game_mode == "solo")
	var my_id = 1 if is_solo else multiplayer.get_unique_id()
	
	if is_solo:
		var p_name = GameManager.players[my_id]["name"]
		var p_color = GameManager.players[my_id]["color"]
		_add_chat_message(p_name, p_color, new_text)
	else:
		rpc_send_message.rpc(my_id, new_text)

@rpc("any_peer", "call_local", "reliable")
func rpc_send_message(sender_id, text):
	var p_name = GameManager.players[sender_id]["name"]
	var p_color = GameManager.players[sender_id]["color"]
	_add_chat_message(p_name, p_color, text)

func _add_chat_message(sender_name, hex_color, text):
	chat_display.append_text("[color=#" + hex_color + "][b]" + sender_name + "[/b][/color]: " + text + "\n")
