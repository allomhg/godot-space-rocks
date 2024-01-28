class_name Player extends CharacterBody2D

@onready var screen_size : Vector2 = get_viewport_rect().size

signal laser_shot(laser)
signal died()

@export var acceleration : float = 10.0
@export var max_speed : float = 350.0
@export var rotation_speed : float = 250.0
@export var rate_of_fire: float = 0.2

@onready var muzzle = $Muzzle # Load Muzzle Node into variable on ready
@onready var player_sprite = $Sprite
@onready var cshape = $CollisionShape2D

var input_vector : Vector2
var shoot_cd : bool = false
var alive : bool = true

var laser_scene = preload("res://scenes/laser.tscn")

func _process(_delta):
	if !alive: return # If the player is not alive, then do nothing
	_has_player_shot()
	screen_wrap()

func _physics_process(delta):
	if !alive: return # If the player is not alive, then do nothing
	_player_move(delta)
	_slow_down()
	move_and_slide()

# Handles the forward/backward movement and rotation of the player
func _player_move(delta):
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
func _slow_down():
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)

# Wraps the player's ship around the screen edges
func screen_wrap():
	#position.x = wrapf(position.x, -10, game_manager.screen_size.x + 10) # Variable to track, min value, max value
	#position.y = wrapf(position.y, -10, game_manager.screen_size.y + 10)
	position.x = wrapf(position.x, -10, screen_size.x + 10) # Variable to track, min value, max value
	position.y = wrapf(position.y, -10, screen_size.y + 10)

# Checks to see if the player has shot and creates a timer to limit rate of fire
func _has_player_shot():
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

# Shoots a laser from the position of the Muzzle Node
# Laser is spawned in a separate Lasers node so that is doesn't inherit movement from the player
func shoot_laser():
	var l = laser_scene.instantiate() # Create the laser scene in game
	l.global_position = muzzle.global_position # Set the position of the laser to the position of Muzzle (Node2D)
	l.rotation = rotation # Set rotation of the laser to the rotation of the player
	emit_signal("laser_shot", l)
	

func player_death():
	if alive == true:
		alive = false
		player_sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

func respawn(pos):
	if !alive:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		player_sprite.visible = true
		cshape.set_deferred("disabled", false)
