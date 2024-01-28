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
@onready var cshape = $CollisionShape2D

func _ready():
	rotation_degrees = randf_range(0, 360)

	match size:
		RockSize.LARGE:
			speed = randf_range(50, 100)
			rock_sprite.texture = preload("res://sprites/large-rock.png")
			cshape.shape = preload("res://resources/SpaceRock_CShape_Large.tres")
		RockSize.MEDIUM:
			speed = randf_range(101, 150)
			rock_sprite.texture = preload("res://sprites/rock.png")
			cshape.shape = preload("res://resources/SpaceRock_CShape_Medium.tres")
		RockSize.SMALL:
			speed = randf_range(151, 200)
			rock_sprite.texture = preload("res://sprites/small-rock.png")
			cshape.shape = preload("res://resources/SpaceRock_CShape_Small.tres")

func _process(delta):
	rock_sprite.rotation_degrees += rotation_speed * delta
	screen_wrap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

 #Wraps the node around the screen edges
func screen_wrap():
	position.x = wrapf(position.x, -cshape.shape.radius, GameManager.screen_size.x + cshape.shape.radius) # Variable to track, min value, max value
	position.y = wrapf(position.y, -cshape.shape.radius, GameManager.screen_size.y + cshape.shape.radius)
