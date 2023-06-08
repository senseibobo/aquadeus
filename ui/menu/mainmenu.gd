extends Control


func _ready():
	Global.play_music(preload("res://sfx/menumusic.mp3"))
	$VBoxContainer/Buttons/Play.grab_focus()
	
func _on_Play_pressed():
	Global.play_sound(preload("res://sfx/menu_click_SFX_2.wav"))
	get_tree().change_scene("res://arena/Arena.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Controls_pressed():
	$Controls.visible = true
	print($Controls.visible)
