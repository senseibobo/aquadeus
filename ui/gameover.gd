extends CanvasLayer

func _input(event):
	if event.is_action_pressed("restart"):
		Global.emit_signal("restart")
		queue_free()

func set_message(message: String):
	#$VBoxContainer/Label2.text = message
	if message.begins_with("Neptun"):
		$AnimationPlayer.play("Neptune")
	else:
		$AnimationPlayer.play("Poseidon")


func animation_finished(anim_name):
	Global.emit_signal("restart")
	queue_free()
