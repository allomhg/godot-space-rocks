extends CharacterBody2D

var input_vector : Vector2

@export var acceleration : float = 10.0
@export var max_speed : float = 350.0
@export var rotation_speed : float = 250.0

@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.

func _ready():
	print(str("Screen size = ", screen_size))

func _physics_process(delta):
	player_move(delta)
	slow_down(input_vector)
	screen_wrap()
	move_and_slide()

# Handles the forward/backward movement and rotation of the player
func player_move(delta):
	# Input.get_axis will return -1, 0, 1 depending on the action.
	# In W it will be (0, -1). If S is pushed it will be (0, 1)
	input_vector = Vector2(0, Input.get_axis("move_forward", "move_backward"))

	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	elif Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed * delta))

# Slowly reduces velocity when there is no input from player
func slow_down(input_vector):
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)

# Wraps the player's ship around the screen edges
func screen_wrap():
	position.x = wrapf(position.x, -10, screen_size.x + 10) # Variable to track, min value, max value
	position.y = wrapf(position.y, -10, screen_size.y + 10)


