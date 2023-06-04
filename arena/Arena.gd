extends Node2D

func _ready():
	Global.connect("restart",self,"restart")
	restart()
	trigger_mojsije()

var fish_timer: float
var fish_cd: float = 7.0

func _process(delta):
	fish_timer -= delta
	if fish_timer <= 0:
		fish_timer += fish_cd
		var fish = preload("res://fish/fishpickup.tscn").instance()
		fish.fish = [preload("res://fish/swordfish.tres")][randi()%1]
		var x = 1920/2 -250 + 500*randf()
		fish.global_position = Vector2(x,-100)
		fish.get_node("Riba1").texture = fish.fish.pickup_texture
		add_child(fish)

func restart():
	$Neptun.global_position = Vector2(1920,1080)/2.0 + Vector2(500,0)
	$Poseidon.global_position = Vector2(1920,1080)/2.0 + Vector2(-500,0)
	$Neptun.restart()
	$Poseidon.restart()

func trigger_mojsije():
	var incoming = preload("res://ui/mojsijeincoming.tscn").instance()
	add_child(incoming)
	yield(incoming,"done")
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($VodaLevo/MojsijePutic,"modulate:a",1.0,0.6)
	tween.tween_property($VodaDesno/MojsijePutic,"modulate:a",1.0,0.6)
	tween.chain()
	tween.tween_property($VodaLevo,"global_position",$VodaLevo.global_position - Vector2(130,0),2.0)
	tween.tween_property($VodaDesno,"global_position",$VodaDesno.global_position + Vector2(130,0),2.0)
	tween.tween_interval(1.0)
	tween.tween_callback(self,"mojsije_walk")
	tween.tween_property(Global,"mojsije_split",true,0)
	tween.chain()
	tween.tween_interval(14.0)
	tween.chain()
	tween.tween_property(Global,"mojsije_split",false,0)
	tween.tween_property($VodaLevo,"global_position",$VodaLevo.global_position,2.0)
	tween.tween_property($VodaDesno,"global_position",$VodaDesno.global_position,2.0)
	tween.chain()
	tween.tween_property($VodaLevo/MojsijePutic,"modulate:a",0.0,0.6)
	tween.tween_property($VodaDesno/MojsijePutic,"modulate:a",0.0,0.6)
	
func mojsije_walk():
	var mojsije = preload("res://characters/mojsije/mojsije.tscn").instance()
	add_child(mojsije)
	mojsije.global_position = Vector2(1920/2,-70)
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(mojsije,"global_position:y",80,1.5)
	tween.tween_interval(3.0)
	tween.tween_property(mojsije,"global_position:y",1200,11.5)
	tween.tween_callback(mojsije,"queue_free")
