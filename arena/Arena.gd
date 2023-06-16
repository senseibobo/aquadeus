extends Node2D


var voda_start = []

var mojsije_timer: Timer
var fish_timer: Timer
var fish_cd: float = 7.0

var game_active: bool = false


func _ready():
	
	mojsije_timer = Timer.new()
	add_child(mojsije_timer)
	mojsije_timer.connect("timeout", Callable(self, "trigger_mojsije"))
	
	fish_timer = Timer.new()
	add_child(fish_timer)
	fish_timer.connect("timeout", Callable(self, "trigger_fish"))
	
	Global.connect("restart", Callable(self, "restart"))
	Global.connect("gameover", Callable(self, "game_over"))
	Global.connect("roundstart", Callable(self, "round_start"))
	
	voda_start.append($VodaLevo.global_position)
	voda_start.append($VodaDesno.global_position)
	
	restart()
	

func game_over():
	stop_timers()
	game_active = false

func round_start():
	start_timers()
	game_active = true

func start_timers():
	mojsije_timer.start(23.0)
	fish_timer.start(fish_cd)

func stop_timers():
	mojsije_timer.stop()
	fish_timer.stop()

func restart():
	var fight321 = preload("res://ui/321.tscn").instantiate()
	add_child(fight321)
	
	if mojsije_tween:
		mojsije_tween.stop()
		
	$VodaLevo.global_position = voda_start[0]
	$VodaDesno.global_position = voda_start[1]
	$VodaDesno/MojsijePutic.modulate.a = 0.0
	$VodaLevo/MojsijePutic.modulate.a = 0.0
	
	$Neptun.global_position = Vector2(1920,1080)/2.0 + Vector2(500,0)
	$Poseidon.global_position = Vector2(1920,1080)/2.0 + Vector2(-500,0)
	$Neptun.restart()
	$Poseidon.restart()
	
	Global.mojsije_split = false

var mojsije_tween: Tween

func trigger_mojsije():
	mojsije_timer.wait_time = 36.0 + randf()*8.0
	var incoming = preload("res://ui/mojsijeincoming.tscn").instantiate()
	add_child(incoming)
	await incoming.done
	mojsije_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	mojsije_tween.tween_property($VodaLevo/MojsijePutic,"modulate:a",1.0,0.6)
	mojsije_tween.tween_property($VodaDesno/MojsijePutic,"modulate:a",1.0,0.6)
	mojsije_tween.chain()
	mojsije_tween.tween_property($VodaLevo,"global_position",$VodaLevo.global_position - Vector2(130,0),2.0)
	mojsije_tween.tween_property($VodaDesno,"global_position",$VodaDesno.global_position + Vector2(130,0),2.0)
	mojsije_tween.tween_interval(1.0)
	mojsije_tween.tween_callback(Callable(self, "mojsije_walk"))
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
	
func trigger_fish():
	var fish = preload("res://fish/fishpickup.tscn").instantiate()
	fish.fish = [preload("res://fish/swordfish.tres")][randi()%1]
	var x = 1920.0/2.0 - 250.0 + 500.0*randf()
	fish.global_position = Vector2(x,-100)
	fish.get_node("Riba1").texture = fish.fish.pickup_texture
	add_child(fish)
	
func mojsije_walk():
	var mojsije = preload("res://characters/mojsije/mojsije.tscn").instantiate()
	add_child(mojsije)
	mojsije.global_position = Vector2(1920.0/2.0,-70.0)
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(mojsije,"global_position:y",80,1.5)
	tween.tween_interval(3.0)
	tween.tween_property(mojsije,"global_position:y",1200,11.5)
	tween.tween_callback(Callable(mojsije, "queue_free"))
