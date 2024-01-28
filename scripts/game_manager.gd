extends Node2D

@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.

var player : CharacterBody2D
var lasers : Node2D
var rocks : Node2D

#@onready var player = $Player
#@onready var lasers = $Lasers
#@onready var rocks = $Rocks

var rock_scene = preload("res://scenes/space_rock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("root/Main/Player")
	lasers = get_node("root/Main/Lasers")
	rocks = get_node("root/Main/Rocks")
	#player = $Player
	#lasers = $Lasers
	#rocks = $Rocks
		
	if rocks != null:
		for rock in rocks.get_children():
			rock.connect("exploded", _on_space_rock_exploded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_space_rock_exploded(pos, size):
	for i in range(2):
		match size:
			SpaceRock.RockSize.LARGE:
				spawn_rock(pos, SpaceRock.RockSize.MEDIUM)
			SpaceRock.RockSize.MEDIUM:
				spawn_rock(pos, SpaceRock.RockSize.SMALL)
			SpaceRock.RockSize.SMALL:
				pass

func spawn_rock(pos, size):
	var a = rock_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_space_rock_exploded)
	rocks.add_child(a)
