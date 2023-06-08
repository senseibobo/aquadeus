extends CanvasLayer

export var multiplier: float = 1.0

var tween: SceneTreeTween

func update_health(health: float):
	
	# update health
	$Healthbar.rect_scale.x = multiplier*health/100.0

func update_fish(fish_array):
	
	# update ui textures according to player's fish
	var i = 0
	for fish in fish_array:
		$Fish.get_child(i).texture = fish.icon_texture if fish else null
		i += 1
			
func update_wins(wins: int):
	for i in 3:
		$Wins.get_child(i).visible = wins > i

func _process(delta):
	$Damage.rect_scale.x = lerp($Damage.rect_scale.x,$Healthbar.rect_scale.x,3.0*delta)

func update_ui(health, fish, wins):
	update_wins(wins)
	update_fish(fish)
	update_health(health)
