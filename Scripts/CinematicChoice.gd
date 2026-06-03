extends Control

# --- DONNÉES DES RUNES ---
# Listes des noms de toutes les options disponibles pour chaque catégorie
const WEAPON_NAMES = ["Buckshot", "Sniper", "Auto Rifle", "SMG", "Burst Pistol", "Revolver", "Lightning Gun", "Grappling Hook", "Flamethrower", "Charge Gun", "Sorcerer Wand", "Grenade Launcher", "Bow", "Plasma Cannon", "Sawed-Off", "Nailgun", "TDE Beam", "Tractor Beam", "Disc Launcher", "Rocket Launcher", "Boomerang", "Energy Whip", "Minigun", "Harpoon", "Slush Launcher"]
const BODY_NAMES = ["Default", "Passive Regen", "Giant", "Thorns", "Triple Jump", "Feather Weight", "Heavy Weight", "Aerodynamic", "Frozen Feet", "Cold Blood", "Reactive Armor", "Microbe", "Invincible", "Vampire Body", "Fire Aura", "Poison Touch", "Lifesteal Aura", "Bomber", "Last Stand", "Feather Falling", "Scum", "Stealth", "Gambler", "Channeler", "Arachnid", "Turtle", "Unstable"]
const ABILITY_NAMES = ["Dash", "Shield", "Reflect", "Shrink", "Heal", "Wall Destruct", "Teleport", "Smash", "Swap", "Smoke", "Ice Wall", "Mines", "Shockwave", "Roll", "Jetpack", "Rawwr", "Invisibility", "Fishing Rod", "Protect Dome", "Solid Dome", "Stasis", "Anchor", "Blink", "Overcharge", "Decoy"]

# --- VARIABLES D'ÉTAT ET UI ---
# Suivi de la progression, stockage des choix du joueur et références visuelles
var current_step = 0 
var selected_runes = {"weapon": 0, "body": 0, "ability": 0}
var cards = []
var is_transitioning = false

@onready var title_label = Label.new()
@onready var status_label = Label.new()

# --- INITIALISATION ET ANIMATION GLOBALE ---
# Mise en place du fond, des textes d'en-tête et animation flottante du titre
func _ready():
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.08, 1.0)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	title_label.set_anchors_preset(PRESET_TOP_WIDE)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.position.y = 100
	add_child(title_label)

	status_label.set_anchors_preset(PRESET_BOTTOM_WIDE)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 32)
	status_label.position.y = get_viewport_rect().size.y - 150
	status_label.hide()
	add_child(status_label)

	start_step()

func _process(_delta):
	if is_instance_valid(title_label):
		title_label.pivot_offset = Vector2(get_viewport_rect().size.x / 2.0, 32)
		title_label.scale = Vector2.ONE * (1.0 + sin(Time.get_ticks_msec() * 0.003) * 0.02)

# --- LOGIQUE DE GÉNÉRATION DES CHOIX ---
# Détermine la catégorie actuelle et tire 3 options aléatoires uniques
func start_step():
	is_transitioning = false
	var choices = []
	var pool_size = 0
	var title_text = ""

	if current_step == 0:
		pool_size = WEAPON_NAMES.size()
		title_text = "Choisissez votre Arme"
	elif current_step == 1:
		pool_size = BODY_NAMES.size()
		title_text = "Choisissez votre Corps"
	else:
		pool_size = ABILITY_NAMES.size()
		title_text = "Choisissez votre Habileté"

	title_label.text = title_text
	title_label.modulate.a = 0
	var tw_title = create_tween()
	tw_title.tween_property(title_label, "modulate:a", 1.0, 0.5)

	while choices.size() < 3:
		var r = randi() % pool_size
		if not choices.has(r): choices.append(r)

	create_cards(choices)

# --- CRÉATION VISUELLE DES CARTES ---
# Instancie les 3 cartes à l'écran, applique les styles, tweens et connecte les signaux d'interaction
func create_cards(choices):
	var screen_center = get_viewport_rect().size / 2.0
	var spacing = 400

	for i in range(3):
		var card = ColorRect.new()
		card.color = Color(0.12, 0.12, 0.15, 1.0)
		card.custom_minimum_size = Vector2(250, 400)
		card.pivot_offset = Vector2(125, 200)

		var target_x = screen_center.x + (i - 1) * spacing - 125
		var target_y = screen_center.y - 150
		card.position = Vector2(target_x, target_y + 800) 
		card.modulate.a = 0.0

		var name_label = Label.new()
		name_label.set_anchors_preset(PRESET_FULL_RECT)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		name_label.add_theme_font_size_override("font_size", 28)

		if current_step == 0: name_label.text = WEAPON_NAMES[choices[i]]
		elif current_step == 1: name_label.text = BODY_NAMES[choices[i]]
		else: name_label.text = ABILITY_NAMES[choices[i]]
		card.add_child(name_label)
		
		var outline = ReferenceRect.new()
		outline.editor_only = false
		outline.border_color = Color(1.0, 0.2, 0.8, 1.0)
		outline.border_width = 4.0
		outline.set_anchors_preset(PRESET_FULL_RECT)
		outline.modulate.a = 0.0
		outline.name = "Outline"
		card.add_child(outline)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		add_child(card)
		cards.append(card)

		card.gui_input.connect(_on_card_gui_input.bind(card, choices[i], i))
		card.mouse_entered.connect(_on_card_hover.bind(card, true))
		card.mouse_exited.connect(_on_card_hover.bind(card, false))
		
		var tw = create_tween().set_parallel(true)
		tw.tween_property(card, "position:y", target_y, 0.7).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(i * 0.15)
		tw.tween_property(card, "modulate:a", 1.0, 0.5).set_delay(i * 0.15)

# --- INTERACTIONS UTILISATEUR ---
# Gestion du survol (agrandissement/soulignage) et du clic (animations de validation et rejet)
func _on_card_hover(card, is_hovering):
	if is_transitioning: return
	var tw = create_tween().set_parallel(true)
	var outline = card.get_node("Outline")
	
	if is_hovering:
		tw.tween_property(card, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_SINE)
		tw.tween_property(card, "color", Color(0.2, 0.15, 0.3, 1.0), 0.2)
		tw.tween_property(outline, "modulate:a", 1.0, 0.2)
	else:
		tw.tween_property(card, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE)
		tw.tween_property(card, "color", Color(0.12, 0.12, 0.15, 1.0), 0.2)
		tw.tween_property(outline, "modulate:a", 0.0, 0.2)

func _on_card_gui_input(event, _card, rune_id, index):
	if is_transitioning: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_transitioning = true
		select_rune(rune_id)

		var tw = create_tween().set_parallel(true)
		for i in range(cards.size()):
			var c = cards[i]
			if i == index:
				tw.tween_property(c, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				tw.tween_property(c, "modulate", Color(2, 2, 2, 1), 0.3) 
				tw.chain().tween_property(c, "modulate:a", 0.0, 0.4)
			else:
				tw.tween_property(c, "position:y", c.position.y + 600, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
				tw.tween_property(c, "modulate:a", 0.0, 0.4)

		tw.chain().tween_callback(next_step)

# --- GESTION DE LA PROGRESSION ---
# Enregistre le choix de la rune et passe à l'étape suivante ou clôture la sélection
func select_rune(rune_id):
	if current_step == 0: selected_runes["weapon"] = rune_id
	elif current_step == 1: selected_runes["body"] = rune_id
	elif current_step == 2: selected_runes["ability"] = rune_id

func next_step():
	for c in cards: c.queue_free()
	cards.clear()

	current_step += 1
	if current_step > 2: finish_selection()
	else: start_step()

# --- FIN DE SÉLECTION ET RÉSEAU ---
# Affiche l'écran d'attente, synchronise le build avec le GameManager local et notifie le serveur
func finish_selection():
	title_label.text = "En attente des autres joueurs..."
	status_label.show()
	status_label.text = "Vous êtes prêt !"
	status_label.modulate = Color(0.2, 1.0, 0.5) 

	var my_id = multiplayer.get_unique_id()
	if GameManager.players.has(my_id):
		GameManager.players[my_id]["weapon"] = selected_runes["weapon"]
		GameManager.players[my_id]["body"] = selected_runes["body"]
		GameManager.players[my_id]["ability"] = selected_runes["ability"]

	rpc_player_ready.rpc_id(1, my_id, selected_runes)

# Validation côté serveur de l'état prêt des joueurs et lancement de la partie
@rpc("any_peer", "call_local", "reliable")
func rpc_player_ready(peer_id, runes):
	if multiplayer.is_server():
		GameManager.players[peer_id]["weapon"] = runes["weapon"]
		GameManager.players[peer_id]["body"] = runes["body"]
		GameManager.players[peer_id]["ability"] = runes["ability"]
		GameManager.players[peer_id]["ready"] = true
		GameManager.sync_to_clients()

		var all_ready = true
		for p in GameManager.players.values():
			if not p["ready"]: all_ready = false

		if all_ready:
			await get_tree().create_timer(1.5).timeout
			rpc_launch_game.rpc()

@rpc("authority", "call_local", "reliable")
func rpc_launch_game():
	get_tree().change_scene_to_file("res://Scenes/Arena.tscn")
