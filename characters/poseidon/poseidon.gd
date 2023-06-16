extends Player


func restart():
	super.restart()
	
	# rotates to face right upon spawning
	last_dir = Vector2.RIGHT
	set_angle(0)
