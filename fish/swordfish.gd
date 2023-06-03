extends Area2D

var dir: Vector2 
var speed: float = 1400.0
var player: int

func _physics_process(delta):
	global_position += dir*speed
