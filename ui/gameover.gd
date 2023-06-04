extends CanvasLayer

func _input(event):
	if event.is_action_pressed("restart"):
		Global.emit_signal("restart")
		queue_free()

func set_message(message: String):
	$VBoxContainer/Label2.text = message
	if message.begins_with("Neptun"):
		$TextureRect.texture = preload("res://ui/NEPTUNE_WINS.png")
	else:
		$TextureRect.texture = preload("res://ui/POSEIDON_WINS.png")
