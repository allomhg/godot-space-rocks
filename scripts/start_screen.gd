extends Control

@export_file("main.tscn") var load_main

@onready var controls_txt : VBoxContainer = get_node("VBoxContainer/ControlsTxtBox/")
@onready var start_screen_ui : Control = $startscreen

func _ready():
	controls_txt.visible = false
	pass

func _on_controls_button_pressed():
	controls_txt.visible = !controls_txt.visible 

func _on_start_button_pressed():
	#get_tree().paused = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
