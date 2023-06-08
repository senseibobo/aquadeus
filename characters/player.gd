extends KinematicBody2D
class_name Player

enum STATE {
	FREE,
	CHARGING,
	ATTACKING,
	ATTACK_DASHING,
	DASHING,
	EATING
}

var state: int = STATE.FREE

var charge_amount: float = 0.0
var speed: float = 780.0
var frozen: bool = true

var wins: int = 0

export(int,1,2) var player: int = 1
export var max_health: float = 100.0
onready var health: float = max_health
onready var ui: CanvasLayer = $UI
onready var trident = $Trident

export var move_up_control: String
export var move_down_control: String
export var move_left_control: String
export var move_right_control: String
export var aim_up_control: String
export var aim_down_control: String
export var aim_left_control: String
export var aim_right_control: String
export var basic_attack_control: String
export var melee_attack_control: String
export var dash_control: String
export var fish_throw_control: String
export var fish_eat_control: String

export var trident_dash_speed: float = 1200.0
export var trident_dash_distance: float = 150.0
var trident_dash_distance_left: float = 0.0

var acceleration: float = 4.8
var velocity: Vector2
var basic_charging = false
var dash_cooldown = 1.4
var dash_cooldown_remaining: float = 0.0

var last_move_dir: Vector2 = Vector2.RIGHT
var last_dir: Vector2

var fish: Array = []

func _ready():
	Global.players[player] = self
	Global.connect("roundstart",self,"_on_round_start")
	trident.connect("returning",self,"_on_trident_return")
	trident.connect("stab",self,"_on_trident_stab")

func _on_trident_stab():
	state = STATE.ATTACK_DASHING
	trident_dash_distance_left = trident_dash_distance

func _on_trident_return():
	state = STATE.FREE

func _process(delta):
	if frozen: return
	dash_cooldown_remaining -= delta
	_apply_mojsije_debuff(delta)
	_process_basic_attack_charge(delta)
	match state:
		STATE.FREE:
			_get_aim_dir()
			_process_basic_attack_input()
			_process_other_input()
		STATE.CHARGING:
			_get_aim_dir()


func _apply_mojsije_debuff(delta):
	if Global.mojsije_split and abs(global_position.x-Global.SCREEN_SIZE.x/2.0) < Global.MOJSIJE_SPLIT_WIDTH:
		velocity = velocity.linear_interpolate(Vector2(),4*acceleration*delta)

func _process_basic_attack_charge(delta):
	if basic_charging:
		charge_amount += delta
		if charge_amount >= 1.0:
			_release_basic_attack()
			
func _process_basic_attack_input():
	if Input.is_action_just_pressed(basic_attack_control): basic_charging = true
	elif Input.is_action_just_released(basic_attack_control): _release_basic_attack()

func _process_other_input():
	if Input.is_action_just_pressed(melee_attack_control) and not trident.attacking: _melee_attack()
	elif Input.is_action_just_pressed(dash_control) and dash_cooldown_remaining <= 0.0: _dash()
	elif Input.is_action_just_pressed(fish_throw_control): _throw_fish()
	elif Input.is_action_just_pressed(fish_eat_control): _eat_fish()

func _melee_attack():
	trident.attack()
	state = STATE.CHARGING
	set_angle(last_dir.angle())

func _dash():
	state = STATE.DASHING
	dash_cooldown_remaining = dash_cooldown
	velocity = last_dir*2.0
	set_angle(last_dir.angle())

func _throw_fish():
	if fish.size() == 0: return
	else:
		var f: Fish = fish[0]
		fish.pop_front()
		var projectile = load(f.throw_scene).instance()
		projectile.dir = last_dir
		projectile.player = player
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.rotation = last_dir.angle()
		ui.update_fish(fish)

func _eat_fish():
	if fish.size() == 0: return
	fish.pop_front()
	health = clamp(health + 20, 0, 100)
	state = STATE.EATING
	get_tree().create_timer(0.6).connect("timeout",self,"set",["state",STATE.FREE])
	ui.update_health(health)
	ui.update_fish(fish)
	Global.play_sound(preload("res://sfx/consume_final.mp3"))
	$CollisionPolygon2D/EatParticles.emitting = true

func _release_basic_attack():
	
	Global.play_sound(preload("res://sfx/Basic_atk_2.mp3"),0.14)
	
	$Trident/ChargeAttackParticles.restart()
	$Trident/ChargeAttackParticles.emitting = false
	
	_launch_projectile(_get_shot_dir())
	basic_charging = false
	charge_amount = 0

func _get_shot_dir():
	_get_aim_dir()
	return last_dir

func _launch_projectile(dir):	
	var puc = load("res://characters/attacks/basic.tscn").instance()
	get_parent().add_child(puc)
	puc.global_position = global_position
	puc.direction = dir
	puc.player = player
	if Global.mojsije_split: charge_amount = 1
	puc.speed *= (1.0+charge_amount*0.5)
	puc.damage *= (1.0+charge_amount*2.0)
	puc.scale = Vector2.ONE*(1.0+charge_amount)
	puc.rotation = dir.angle()	

func set_angle(angle):
	$CollisionPolygon2D.rotation = angle - PI/2.0
	trident.rotation = angle
	
func _get_move_dir():
	var h_move = Input.get_axis(move_left_control,move_right_control)
	var v_move = Input.get_axis(move_up_control,move_down_control)
	var move_vec = Vector2(h_move/2.0,v_move/2.0).normalized()
	if move_vec != Vector2():
		last_move_dir = move_vec
	return move_vec

func _get_aim_dir():
	var h_dir = Input.get_axis(aim_left_control,aim_right_control)
	var v_dir = Input.get_axis(aim_up_control,aim_down_control)
	var dir = Vector2(h_dir/2.0,v_dir/2.0).normalized()
	if dir != Vector2():
		set_angle(dir.angle())
		last_dir = dir
	return dir

func _physics_process(delta):
	if frozen: return
	_apply_screen_edge_bounce(delta)
	match state:
		STATE.FREE: _physics_process_free(delta)
		STATE.CHARGING: _physics_process_charging(delta)
		STATE.ATTACK_DASHING: _physics_process_attack_dashing(delta)
		STATE.DASHING:_physics_process_dashing(delta)
		STATE.EATING: _physics_process_eating(delta)

func _physics_process_eating(delta):
	move_and_slide(velocity*speed)
	velocity = velocity.linear_interpolate(Vector2(),2*acceleration*delta)

func _physics_process_dashing(delta):
	move_and_slide(velocity*speed)
	velocity = velocity.linear_interpolate(Vector2(),acceleration*delta)
	if velocity.length() < 0.1:
		state = STATE.FREE
		
func _physics_process_attack_dashing(delta):
		move_and_slide(last_dir*trident_dash_speed)
		trident_dash_distance_left -= delta*trident_dash_speed

func _physics_process_charging(delta):
	set_angle(last_dir.angle())
	move_and_slide(velocity*speed)
	velocity = velocity.linear_interpolate(Vector2(),acceleration*delta)
			
func _physics_process_free(delta):
		var move_vec = _get_move_dir()
		velocity = velocity.linear_interpolate(move_vec,acceleration*delta)
		move_and_slide(velocity*speed)
		
func _apply_screen_edge_bounce(delta):
	if not Rect2(Vector2(),Global.SCREEN_SIZE).has_point(global_position):
		if global_position.x < 0.0:
			velocity.x = lerp(velocity.x, 5, 10.0*delta)
		if global_position.y < 0.0:
			velocity.y = lerp(velocity.y, 5, 10.0*delta)
		if global_position.x > Global.SCREEN_SIZE.x:
			velocity.x = lerp(velocity.x, -5, 10.0*delta)
		if global_position.y > Global.SCREEN_SIZE.y:
			velocity.y = lerp(velocity.y, -5, 10.0*delta)


func hit(damage: float):
	if frozen: return
	if state == STATE.DASHING: return
	Global.play_sound(preload("res://sfx/spflash_sound.mp3"))
	health -= damage
	if health <= 0:
		death()
	ui.update_health(health)

func death():

	Global.emit_signal("gameover")
	Global.players[3-player].wins += 1
	Global.players[3-player].ui.update_wins(Global.players[3-player].wins)
	if Global.players[3-player].wins == 2:
		var game_over = preload("res://ui/gameend.tscn").instance()
		game_over.winner = 3-player
		Global.add_child(game_over)
		Global.players = {}
	else:
		var death_screen = preload("res://ui/gameover.tscn").instance()
		Global.add_child(death_screen)
		print(Global.players)
		
		death_screen.set_message(Global.players[3-player].name + " je pobedio :D")
		Global.players[3-player].ui.update_wins(wins)
	
func restart():
	velocity = Vector2()
	state = STATE.FREE
	basic_charging = false
	health = max_health
	fish = []
	ui.update_ui(health,fish,wins)
	
func _on_round_start():
	frozen = false

func acquire_fish(fish: Fish):
	if self.fish.size() < 5:
		self.fish.append(fish)
		ui.update_fish(self.fish)
		return true
	else:
		return false

