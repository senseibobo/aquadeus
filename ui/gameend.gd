extends CanvasLayer

var winner: int

func _ready():
	var n = ["Neptune","Poseidon"][winner-1]
	$AnimationPlayer.play(n)
	$VBoxContainer/Label.text = n + " wins"

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		queue_free()
	elif event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene("res://ui/menu/mainmenu.tscn")
		queue_free()
