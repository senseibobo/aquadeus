extends Node

signal restart
signal gameover

var mojsije_split: bool = false
var players = {}

func _ready():
	connect("gameover",self,"game_over")

func _input(event):
	if event.is_action_pressed("main_menu"):
		get_tree().change_scene("res://ui/menu/mainmenu.tscn")

func game_over():
	print("gejm over")
	for player_id in players:
		players[player_id].frozen = true
