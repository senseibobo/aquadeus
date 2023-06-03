extends Area2D
class_name Projectile

#export var distance_left: float = 790.0
export var player: int
export var speed: float = 1500.0
export var deceleration: float = 1400.0
export var direction: Vector2 = Vector2(1,1)
export var damage: float = 5.0

func _physics_process(delta):
	#distance_left -= speed*delta
#	if distance_left <= 0:
	speed = move_toward(speed,0,deceleration*delta)
	if speed == 0:
		queue_free()
	global_position += direction*speed*delta


func on_hit(body):
	if body is Player:
		print(str(player) + " hit " + str(body.player))
		if body.player != player:
			print("hit")
			body.hit(damage)
			queue_free()
	else:
		queue_free()
