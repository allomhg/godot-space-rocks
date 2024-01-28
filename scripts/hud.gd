extends Control

@onready var score = $Score:
	set(value):
		score.text = str("SCORE: ",value)

@onready var lives = $LivesHBox

var ui_life_scene = preload("res://scenes/ui_life.tscn")

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	
	for i in amount:
		var ul = ui_life_scene.instantiate()
		lives.add_child(ul)
