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

func attack():
	if attacking: return
	attacking = true
	$AnimationPlayer.play("attack")

func _returned():
	attacking = false
