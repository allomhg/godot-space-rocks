extends Node2D

#@onready var screen_size : Vector2 = get_viewport_rect().size # Returns Vector2D of screen size.

@onready var player = $Player
@onready var lasers = $Lasers
@onready var rocks = $Rocks
@onready var hud = $UI/HUD
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn = $PlayerSpawnPosition
@onready var player_spawn_area = $PlayerSpawnPosition/PlayerSpawnArea
@onready var laser_sound = $LaserSound
#@onready var game_music = $GameMusic

var space_rock_scene = preload("res://scenes/space_rock.tscn")
var rock_count: int = 0

var score : int:
	set(value):
		score = value
		hud.score = score
		
var lives : int:
	set(value):
		lives = value
		hud.init_lives(lives)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_screen.visible = false
	lives = 3
	score = 0
	
	
	if rocks != null:
		for rock in rocks.get_children():
			rock.connect("exploded", _on_space_rock_exploded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Restart the game if R is pressed
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	# Spawn new rocks when $Rocks Node is empty
	rock_count = rocks.get_child_count()
	if rock_count == 0:
		spawn_new_rocks()

func _on_player_laser_shot(laser):
	laser_sound.pitch_scale = randf_range(0.80, 1.50)
	laser_sound.play()
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
	$RockExplodedSound.play()

func spawn_rock(pos, size):
	var a = space_rock_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_space_rock_exploded)
	#a.connect("body_entered", _on_body_entered)
	#rocks.add_child(a) # Cannot use this as it creates an error
	rocks.call_deferred("add_child", a) # Use this instead

# !!! NEED TO ADD FUNCTIONALITY TO NOT SPAWN IN CENTRE OF SCREEN OR NEAR PLAYER !!! #
# Create a function that spawns size more large rocks when the $Rocks Node is empty
func spawn_new_rocks():
	var rand_x_pos: float
	var rand_y_pos: float
	
	for i in range(6):
		var new_rock = space_rock_scene.instantiate()
		rand_x_pos = randf_range(0, 1280)
		rand_y_pos = randf_range(0, 720)
		new_rock.global_position = Vector2(rand_x_pos, rand_y_pos)
		new_rock.size = SpaceRock.RockSize.LARGE
		new_rock.connect("exploded", _on_space_rock_exploded)
		rocks.call_deferred("add_child", new_rock)

# Handles what happens when the player dies, depending on the number of lives they have
func _on_player_died():
	$PlayerDeathSound.play()
	lives -= 1
	player.global_position = player_spawn.global_position
	
	# If player loses all lives display game over screen after a delay
	if lives <= 0:
		await get_tree().create_timer(2).timeout
		game_over_screen.visible = true
	# Respawn the player if the spawn area if empty
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn_area.is_empty:
			await get_tree().create_timer(0.1).timeout
		player.respawn(player_spawn.global_position)
	
