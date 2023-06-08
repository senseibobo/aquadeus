extends Node2D

func _ready():
	# disappears when the round ends
	Global.connect("restart",self,"queue_free")

func _on_Area2D_body_entered(body):
	# instakill on touch
	body.hit(100)
	# add some effect here 
