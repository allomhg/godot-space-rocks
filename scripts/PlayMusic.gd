extends Node2D

@onready var game_music : AudioStreamPlayer = $GameMusic

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_music.playing == false:
		game_music.play()
