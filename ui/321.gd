extends CanvasLayer


func _ready():
	pass

func start_round(anim):
	Global.emit_signal("roundstart")
	queue_free()