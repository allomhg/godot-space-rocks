extends Node2D

@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.
@onready var lasers = $Lasers
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
#func _ready():
	##player.connect("laser_shot", _on_player_laser_shot) 
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)
