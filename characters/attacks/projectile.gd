extends Area2D
class_name Projectile

export var player: int
export var speed: float = 1500.0
export var deceleration: float = 1400.0
export var direction: Vector2 = Vector2(1,1)

export(float,0.0,100.0) var damage: float = 5.0


func _ready():
	Global.connect("restart",self,"queue_free")

func _physics_process(delta):
	
	speed = move_toward(speed,0,deceleration*delta)
	if speed <= 0.1:
		queue_free()
	global_position += direction*speed*delta

func on_hit(body):
	if body is Player:
		if body.player != player:
			body.hit(damage)
			death()
	else:
		death()

func death():
	var particles = $Particles2D
	remove_child(particles)
	get_parent().add_child(particles)
	get_tree().create_timer(0.3).connect("timeout",particles,"queue_free")
	queue_free()
		
