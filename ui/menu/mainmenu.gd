extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.play_music(preload("res://sfx/menumusic.mp3"))
	$VBoxContainer/Buttons/Play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	Global.play_sound(preload("res://sfx/menu_click_SFX_2.wav"))
	get_tree().change_scene("res://arena/Arena.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Controls_pressed():
	$Controls.visible = true
	print($Controls.visible)
