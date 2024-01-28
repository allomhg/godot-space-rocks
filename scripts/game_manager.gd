extends Node2D

#@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.

var score : int = 0

var player : CharacterBody2D
var lasers : Node2D
var rocks : Node2D

var rock_scene = preload("res://scenes/space_rock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	lasers = $Lasers
	rocks = $Rocks
		
	if rocks != null:
		for rock in rocks.get_children():
			rock.connect("exploded", _on_space_rock_exploded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_space_rock_exploded(pos, size, points):
	score += points
	for i in range(2):
		match size:
			SpaceRock.RockSize.LARGE:
				spawn_rock(pos, SpaceRock.RockSize.MEDIUM)
			SpaceRock.RockSize.MEDIUM:
				spawn_rock(pos, SpaceRock.RockSize.SMALL)
			SpaceRock.RockSize.SMALL:
				pass
	print(score)
func spawn_rock(pos, size):
	var a = rock_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_space_rock_exploded)
	#a.connect("body_entered", _on_body_entered)
	#rocks.add_child(a) # Cannot use this as it creates an error
	rocks.call_deferred("add_child", a) # Use this instead
