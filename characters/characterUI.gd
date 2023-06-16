extends CanvasLayer

@export var multiplier: float = 1.0

var tween: Tween

func update_health(health: float):
	
	# update health
	$Healthbar.scale.x = multiplier*health/100.0

func update_fish(fish_array):
	
	# update ui textures according to player's fish
	for i in 5:
		$Fish.get_child(i).texture = fish_array[i].icon_texture if fish_array.size() > i else null
			
func update_wins(wins: int):
	for i in 3:
		$Wins.get_child(i).visible = wins > i

func _process(delta):
	$Damage.scale.x = lerp($Damage.scale.x,$Healthbar.scale.x,3.0*delta)

func update_ui(health, fish, wins):
	update_wins(wins)
	update_fish(fish)
	update_health(health)
