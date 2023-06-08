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
	Global.play_sound(preload("res://sfx/melee_lunge_with_wind_up.mp3"))
	attacking = true
	# animation
	var tween = create_tween()
	tween.tween_callback(self,"emit_signal",["start_charging"])
	tween.tween_property($Trident,"position", Vector2(-25,16), 0.6)
	tween.tween_callback(self,"emit_signal",["stab"])
	tween.tween_property($Trident,"position", Vector2(40,16), 0.1)
	tween.tween_callback(self,"emit_signal",["stabbed"])
	tween.tween_interval(0.3)
	tween.tween_callback(self,"emit_signal",["returning"])
	tween.tween_property($Trident,"position",Vector2(0,16),0.2)
	tween.tween_callback(self,"emit_signal",["returned"])
	
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
			Global.play_sound(preload("res://sfx/melee_attack_hit.mp3"))
			body.hit(20)
