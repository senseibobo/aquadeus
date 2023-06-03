extends Node

signal restart
signal gameover

var players = {}

func _ready():
	connect("gameover",self,"game_over")

func game_over():
	for player_id in players:
		players[player_id].frozen = true
