extends Node2D

func _ready():
	Global.connect("restart",self,"restart")
	restart()
	voda_start.append($VodaLevo.global_position)
	voda_start.append($VodaDesno.global_position)
	
	Global.connect("gameover",self,"game_over")
	Global.connect("roundstart",self,"round_start")

var mojsije_timer: float = 23.0

var voda_start = []

var fish_timer: float
var fish_cd: float = 7.0
var game_active: bool = false

func game_over():
	game_active = false

func round_start():
	game_active = true

func _process(delta):
	if not game_active: return
	mojsije_timer -= delta
	if mojsije_timer <= 0:
		mojsije_timer += 36.0 + randf()*12
		trigger_mojsije()
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
	mojsije_timer = 20.0
	var fight321 = preload("res://ui/321.tscn").instance()
	add_child(fight321)
	if mojsije_tween:
		mojsije_tween.stop()
	if voda_start.size() > 0:
		$VodaLevo.global_position = voda_start[0]
		$VodaDesno.global_position = voda_start[1]
	$VodaDesno/MojsijePutic.modulate.a = 0.0
	$VodaLevo/MojsijePutic.modulate.a = 0.0
	$Neptun.global_position = Vector2(1920,1080)/2.0 + Vector2(500,0)
	$Poseidon.global_position = Vector2(1920,1080)/2.0 + Vector2(-500,0)
	$Neptun.restart()
	$Poseidon.restart()
	Global.mojsije_split = false

var mojsije_tween: SceneTreeTween

func trigger_mojsije():
	var incoming = preload("res://ui/mojsijeincoming.tscn").instance()
	add_child(incoming)
	yield(incoming,"done")
	mojsije_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	mojsije_tween.tween_property($VodaLevo/MojsijePutic,"modulate:a",1.0,0.6)
	mojsije_tween.tween_property($VodaDesno/MojsijePutic,"modulate:a",1.0,0.6)
	mojsije_tween.chain()
	mojsije_tween.tween_property($VodaLevo,"global_position",$VodaLevo.global_position - Vector2(130,0),2.0)
	mojsije_tween.tween_property($VodaDesno,"global_position",$VodaDesno.global_position + Vector2(130,0),2.0)
	mojsije_tween.tween_interval(1.0)
	mojsije_tween.tween_callback(self,"mojsije_walk")
	mojsije_tween.tween_property(Global,"mojsije_split",true,0)
	mojsije_tween.chain()
	mojsije_tween.tween_interval(14.0)
	mojsije_tween.chain()
	mojsije_tween.tween_property(Global,"mojsije_split",false,0)
	mojsije_tween.tween_property($VodaLevo,"global_position",$VodaLevo.global_position,2.0)
	mojsije_tween.tween_property($VodaDesno,"global_position",$VodaDesno.global_position,2.0)
	mojsije_tween.chain()
	mojsije_tween.tween_property($VodaLevo/MojsijePutic,"modulate:a",0.0,0.6)
	mojsije_tween.tween_property($VodaDesno/MojsijePutic,"modulate:a",0.0,0.6)
	
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
