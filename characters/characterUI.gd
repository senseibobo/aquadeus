extends CanvasLayer

export var multiplier: float = 1.0

func update_ui(health: float):
	$Healthbar.rect_scale.x = multiplier*health/100.0
