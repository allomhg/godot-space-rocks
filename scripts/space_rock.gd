class_name SpaceRock extends Area2D

signal exploded(pos, size) # Send position and size of rock when exploded

enum RockSize {
	LARGE,
	MEDIUM,
	SMALL
}

var movement_vector : Vector2 = Vector2(0, -1)
var speed : float = 50.0
var rotation_speed : float = randf_range(10.0, 100.0)

@export var size = RockSize.LARGE

@onready var rock_sprite = $Sprite
@onready var cshape = $CollisionShape2D

func _ready():
	rotation_degrees = randf_range(0, 360)

	match size:
		RockSize.LARGE:
			speed = randf_range(50, 100)
			rock_sprite.texture = preload("res://sprites/large-rock.png")
			cshape.shape = preload("res://resources/rock_cshape_large.tres")
		RockSize.MEDIUM:
			speed = randf_range(101, 150)
			rock_sprite.texture = preload("res://sprites/rock.png")
			cshape.shape = preload("res://resources/rock_cshape_medium.tres")
		RockSize.SMALL:
			speed = randf_range(151, 200)
			rock_sprite.texture = preload("res://sprites/small-rock.png")
			cshape.shape = preload("res://resources/rock_cshape_small.tres")

func _process(delta):
	rock_sprite.rotation_degrees += rotation_speed * delta
	rock_screen_wrap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func explode():
	emit_signal("exploded", global_position, size)
	queue_free()

 #Wraps the node around the screen edges
func rock_screen_wrap():
	var cshape_radius = cshape.shape.radius # Get the radius of the collision shape
	position.x = wrapf(position.x, -cshape_radius, game_manager.screen_size.x + cshape_radius) # Variable to track, min value, max value
	position.y = wrapf(position.y, -cshape_radius, game_manager.screen_size.y + cshape_radius)

func _on_body_entered(body):
	#print("yes")
	#print(body)
	if body.is_in_group("Player"):
		body.game_over()
