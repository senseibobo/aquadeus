extends Node

signal restart
signal gameover
signal roundstart
var mojsije_split: bool = false
var players = {}

func _ready():
	connect("gameover",self,"game_over")
	connect("roundstart",self,"round_start")

func _input(event):
	if event.is_action_pressed("main_menu"):
		get_tree().change_scene("res://ui/menu/mainmenu.tscn")

func play_sound(sound: AudioStream, start_position: float = 0.0, volume: float = 0.0):
	var ap = AudioStreamPlayer.new()
	ap.stream = sound
	add_child(ap)
	ap.volume_db = volume
	ap.play()
	ap.seek(start_position)
	ap.connect("finished",ap,"queue_free")
	return ap

func game_over():
	print("gejm over")
	for player_id in players:
		players[player_id].frozen = true

func round_start():
	pass
