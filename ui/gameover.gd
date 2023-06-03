extends CanvasLayer

func _input(event):
	if event.is_action_pressed("restart"):
		Global.emit_signal("restart")
		queue_free()

func set_message(message):
	$VBoxContainer/Label2.text = message
