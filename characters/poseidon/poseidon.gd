extends Player


func restart():
	super.restart()
	
	# rotates to face right upon spawning
	ui.update_ui(health,fish,wins)
	last_dir = Vector2.RIGHT
	set_angle(0)
