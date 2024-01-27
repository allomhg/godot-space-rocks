extends Area2D

var movement_vector : Vector2 = Vector2(0, -1)

@export var speed : float = 500.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

# Delete the laser when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	#print("Deleted" + name)
	queue_free()
