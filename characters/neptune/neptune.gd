extends Player


func restart():
	.restart()
	
	# rotates to face left upon spawning
	last_dir = Vector2.LEFT
	set_angle(PI)
