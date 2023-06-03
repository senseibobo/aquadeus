extends Area2D
class_name Projectile

export var distance_left: float = 790.0
export var player: int
export var speed: float = 760.0
export var direction: Vector2 = Vector2(1,1)

func _physics_process(delta):
	distance_left -= speed*delta
	if distance_left <= 0:
		queue_free()
	global_position += direction*speed*delta


func on_hit(body):
	if body is Player:
		if body.player != player:
			body.hit(5)
			queue_free()
	else:
		queue_free()
