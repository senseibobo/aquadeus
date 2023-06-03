extends Node2D

signal start_charging
signal stab
signal stabbed
signal returning
signal returned

var attacking: bool = false

export(int,1,2) var player = 1

func _ready():
	connect("returned",self,"_returned")
	Global.connect("gameover",self,"game_over")

func attack():
	if attacking: return
	attacking = true
	$Trident/Hitbox.set_deferred("monitoring",true)
	$AnimationPlayer.play("attack")

func _returned():
	$Trident/Hitbox.set_deferred("monitoring",false)
	attacking = false

func restart():
	$Trident/Hitbox.set_deferred("monitoring",false)

func game_over():
	$Trident/Hitbox.set_deferred("monitoring",false)

func on_hit(body):
	if body is Player:
		if body != get_parent():
			print(str(get_parent().name) + " je udario " + body.name)
			body.hit(20)
