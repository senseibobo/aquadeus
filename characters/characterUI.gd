extends CanvasLayer

export var multiplier: float = 1.0

var tween: SceneTreeTween

func update_ui(health: float):
	$Healthbar.rect_scale.x = multiplier*health/100.0
	print($Damage.rect_scale.x)

func fill_fish(fish_array):
	for child in $Fish.get_children():
		child.texture = null
	var i = 0
	print(fish_array)
	for fish in fish_array:
		if fish:
			$Fish.get_child(i).texture = fish.icon_texture
		i += 1
			

func _process(delta):
	$Damage.rect_scale.x = lerp($Damage.rect_scale.x,$Healthbar.rect_scale.x,3.0*delta)
