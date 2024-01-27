extends Area2D

enum RockSize {
	LARGE,
	MEDIUM,
	SMALL
}

var movement_vector : Vector2 = Vector2(0, -1)
var speed : float = 50.0
var rotation_speed : float = 25.0

@export var size = RockSize.LARGE

@onready var rock_sprite = $Sprite

func _ready():
	rotation_degrees = randf_range(0, 360)

	match size:
		RockSize.LARGE:
			speed = randf_range(30, 50)
		RockSize.MEDIUM:
			speed = randf_range(55, 70)
		RockSize.SMALL:
			speed = randf_range(75, 90)

func _process(delta):
	rock_sprite.rotation_degrees += rotation_speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta


