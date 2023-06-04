extends CanvasLayer


func _input(event):
	if event.is_action_pressed("return_to_main_menu") and visible:
		visible = false
