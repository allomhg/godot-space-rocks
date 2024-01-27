extends CharacterBody2D

signal laser_shot(laser)

@export var acceleration : float = 10.0
@export var max_speed : float = 350.0
@export var rotation_speed : float = 250.0
@export var rate_of_fire: float = 0.2

@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.
@onready var muzzle = $Muzzle # Load Muzzle Node into variable on ready

var input_vector : Vector2
var laser_scene = preload("res://scenes/Laser.tscn")
var shoot_cd : bool = false

func _ready():
	print(str("Screen size = ", screen_size))

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	player_move(delta)
	slow_down()
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
func slow_down():
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)

# Wraps the player's ship around the screen edges
func screen_wrap():
	position.x = wrapf(position.x, -10, screen_size.x + 10) # Variable to track, min value, max value
	position.y = wrapf(position.y, -10, screen_size.y + 10)

# Shoots a laser from the position of the Muzzle Node
# Laser is spawned in a separate node so that is does inherit movement from the player
func shoot_laser():
	var l = laser_scene.instantiate() # Create the laser scene in game
	l.global_position = muzzle.global_position # Set the position of the laser to the position of Muzzle (Node2D)
	l.rotation = rotation # Set rotation of the laser to the rotation of the player
	emit_signal("laser_shot", l)

