extends Node2D

func _ready():
	Global.connect("restart",self,"restart")
	restart()
	
func restart():
	$Neptun.global_position = Vector2(1920,1080)/2.0 + Vector2(500,0)
	$Poseidon.global_position = Vector2(1920,1080)/2.0 + Vector2(-500,0)
	$Neptun.restart()
	$Poseidon.restart()
