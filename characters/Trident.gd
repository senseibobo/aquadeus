extends Node2D

signal start_charging
signal stab
signal stabbed
signal returning
signal returned

var attacking: bool = false

export(int,1,2) var player = 1

func _ready():
	connect("returning",self,"_returning")
	connect("returned",self,"_returned")
	connect("stab",$Trident/Hitbox,"set_deferred",["monitoring",true])
	Global.connect("gameover",self,"game_over")

func attack():
	if attacking: return
	attacking = true
	$AnimationPlayer.play("attack")
	
func _returned():
	attacking = false

func _returning():
	$Trident/Hitbox.set_deferred("monitoring",false)

func restart():
	$Trident/Hitbox.set_deferred("monitoring",false)

func game_over():
	$Trident/Hitbox.set_deferred("monitoring",false)

func on_hit(body):
	if body is Player:
		if body != get_parent():
			print(str(get_parent().name) + " je udario " + body.name)
			body.hit(20)
