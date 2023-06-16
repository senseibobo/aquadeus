extends Area2D

var dir: Vector2 
var speed: float = 1400.0
var player: int

func _ready():
	Global.connect("restart", Callable(self, "queue_free"))

func _physics_process(delta):
	global_position += dir*speed*delta


func _on_Swordfish_body_entered(body):
	if body is Player:
		if body.player != player:
			body.hit(20)
