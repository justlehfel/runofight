extends Control

func _ready():
 
	$VBoxContainer/BtnPlay.pressed.connect(func(): get_tree().change_scene_to_file("res://Scenes/Arena.tscn"))
	$VBoxContainer/BtnQuit.pressed.connect(func(): get_tree().quit());
	
