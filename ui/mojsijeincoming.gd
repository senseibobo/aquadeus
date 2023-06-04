extends CanvasLayer

signal done

func _ready():
	$Label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property($Label,"modulate:a",1.0,0.5)
	tween.tween_interval(1.0)
	tween.tween_property($Label,"modulate:a",0.0,0.5)
	tween.tween_interval(2.0)
	tween.tween_callback(self,"emit_signal",["done"])
	tween.tween_callback(self,"queue_free")
