extends Node

signal restart
signal gameover
signal roundstart
var mojsije_split: bool = false
var players = {}

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(music_player)
	connect("gameover",self,"game_over")
	connect("roundstart",self,"round_start")


func play_music(music: AudioStream):
	var tween = create_tween()
	if music_player.playing:
		tween.tween_property(music_player,"volume_db",-100.0,0.5)
	tween.tween_callback(music_player,"stop")
	tween.tween_property(music_player,"stream",music,0)
	tween.tween_callback(music_player,"play")
	tween.tween_property(music_player,"volume_db",-8.0,0.5)

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
