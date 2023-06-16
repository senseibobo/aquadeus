extends CanvasLayer

signal done

func _ready():
	$Label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property($Label,"modulate:a",1.0,0.5)
	tween.tween_interval(1.0)
	tween.tween_property($Label,"modulate:a",0.0,0.5)
	tween.tween_interval(2.0)
	tween.tween_callback(Callable(self, "emit_signal").bind("done"))
	tween.tween_callback(Callable(self, "queue_free"))
