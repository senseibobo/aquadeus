extends KinematicBody2D
class_name Player

enum STATE {
	FREE,
	CHARGING,
	ATTACKING,
	ATTACK_DASHING,
	DASHING
}

var state: int = STATE.FREE

var charge_amount: float = 0.0
var speed: float = 780.0
var frozen: bool = false

export(int,1,2) var player: int
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
	trident.connect("returning",self,"trident_returned")
	trident.connect("stab",self,"trident_stabbing")
	Global.players[player] = self

func trident_stabbing():
	state = STATE.ATTACK_DASHING
	trident_dash_distance_left = trident_dash_distance

func trident_returned():
	state = STATE.FREE

func _process(delta):
	
	#print(name + " " + str(state))
	if frozen: return
	dash_cooldown_remaining -= delta
	if basic_charging:
		charge_amount += delta
		if charge_amount >= 1.0:
			release_basic_attack()
	match state:
		STATE.FREE:
			get_aim_dir()
			if Input.is_action_just_pressed(basic_attack_control):
				basic_charging = true
				$Trident/ChargeAttackParticles.emitting = true
			elif Input.is_action_just_released(basic_attack_control):
				release_basic_attack()
			if Input.is_action_just_pressed(melee_attack_control) and not trident.attacking:
				trident.attack()
				state = STATE.CHARGING
				set_angle(last_dir.angle())
			elif Input.is_action_just_pressed(dash_control) and dash_cooldown_remaining <= 0.0:
				state = STATE.DASHING
				dash_cooldown_remaining = dash_cooldown
				velocity = last_dir*2.0
				set_angle(last_dir.angle())
			elif Input.is_action_just_pressed(fish_throw_control):
				throw_fish()
		STATE.CHARGING:
			get_aim_dir()

func release_basic_attack():
	$Trident/ChargeAttackParticles.restart()
	$Trident/ChargeAttackParticles.emitting = false
	basic_charging = false
	var dir = get_aim_dir()
	if dir == Vector2():
		dir = last_dir
#	var dir = velocity.normalized()
	var puc = load("res://characters/attacks/basic.tscn").instance()
	get_parent().add_child(puc)
	puc.global_position = global_position
	puc.direction = dir
	puc.player = player
	puc.speed *= (1.0+charge_amount*0.5)
	puc.damage *= (1.0+charge_amount*2.0)
	puc.scale = Vector2.ONE*(1.0+charge_amount)
	puc.rotation = dir.angle()
	charge_amount = 0
	
func throw_fish():
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
		ui.fill_fish(fish)

func set_angle(angle):
	$CollisionPolygon2D.rotation = angle - PI/2.0
	trident.rotation = angle

func _physics_process(delta):
	if frozen: return
	if not Rect2(0,0,1920,1080).has_point(global_position):
		if global_position.x < 0.0:
			print("idem udesno")
			velocity.x = lerp(velocity.x, 5, 10.0*delta)
		if global_position.y < 0.0:
			velocity.y = lerp(velocity.y, 5, 10.0*delta)
		if global_position.x > 1920.0:
			velocity.x = lerp(velocity.x, -5, 10.0*delta)
		if global_position.y > 1080.0:
			velocity.y = lerp(velocity.y, -5, 10.0*delta)
	match state:
		STATE.FREE:
			#set_angle(velocity.angle())
			var move_vec = get_move_dir()
			velocity = velocity.linear_interpolate(move_vec,acceleration*delta)
			move_and_slide(velocity*speed)
		STATE.CHARGING:
			set_angle(last_dir.angle())
			move_and_slide(velocity*speed)
			velocity = velocity.linear_interpolate(Vector2(),acceleration*delta)
		STATE.ATTACK_DASHING:
			move_and_slide(last_dir*trident_dash_speed)
			trident_dash_distance_left -= delta*trident_dash_speed
		STATE.DASHING:
			move_and_slide(velocity*speed)
			velocity = velocity.linear_interpolate(Vector2(),acceleration*delta)
			if velocity.length() < 0.1:
				state = STATE.FREE

func get_move_dir():
	var h_move = Input.get_axis(move_left_control,move_right_control)
	var v_move = Input.get_axis(move_up_control,move_down_control)
	var move_vec = Vector2(h_move/2.0,v_move/2.0).normalized()
	if move_vec != Vector2():
		last_move_dir = move_vec
	return move_vec

func get_aim_dir():
	var h_dir = Input.get_axis(aim_left_control,aim_right_control)
	var v_dir = Input.get_axis(aim_up_control,aim_down_control)
	var dir = Vector2(h_dir/2.0,v_dir/2.0).normalized()
	if dir != Vector2():
		set_angle(dir.angle())
		last_dir = dir
	return dir

func hit(damage: float):
	if frozen: return
	if state == STATE.DASHING: return
	health -= damage
	if health <= 0:
		death()
	ui.update_ui(health)

func death():
	Global.emit_signal("gameover")
	var death_screen = preload("res://ui/gameover.tscn").instance()
	Global.add_child(death_screen)
	death_screen.set_message(("Neptun" if name == "Poseidon" else "Poseidon") + " je pobedio :D")

func restart():
	velocity = Vector2()
	frozen = false
	state = STATE.FREE
	basic_charging = false
	health = max_health
	ui.update_ui(health)
	fish = []
	ui.fill_fish([])

func acquire_fish(fish: Fish):
	if self.fish.size() < 5:
		self.fish.append(fish)
		ui.fill_fish(self.fish)
		return true
	else:
		return false

