extends Area2D

var dir: int = 1
var speed: float = 100.0
var fish: Fish

func _ready():
	Global.connect("restart",self,"queue_free")

func _physics_process(delta):
	global_position.y += dir*speed*delta
	if global_position.y > 1200:
		queue_free()
	


func _on_FishPickup_body_entered(body):
	if body.acquire_fish(fish):
		queue_free()
