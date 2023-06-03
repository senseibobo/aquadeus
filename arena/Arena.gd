extends Node2D

func _ready():
	Global.connect("restart",self,"restart")
	restart()

var fish_timer: float
var fish_cd: float = 3.0

func _process(delta):
	fish_timer -= delta
	if fish_timer <= 0:
		fish_timer += fish_cd
		var fish = preload("res://fish/fishpickup.tscn").instance()
		fish.fish = [preload("res://fish/swordfish.tres")][randi()%1]
		var x = 1920/2 + 500+200*randf()
		fish.global_position = Vector2(x,-100)
		fish.get_node("Riba1").texture = fish.fish.texture
		add_child(fish)

func restart():
	$Neptun.global_position = Vector2(1920,1080)/2.0 + Vector2(500,0)
	$Poseidon.global_position = Vector2(1920,1080)/2.0 + Vector2(-500,0)
	$Neptun.restart()
	$Poseidon.restart()
