extends KinematicBody2D
class_name Player

enum STATE {
	FREE,
	CHARGING,
	ATTACKING,
	ATTACK_DASHING
}

var state: int = STATE.FREE

var speed: float = 460.0
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

export var trident_dash_speed: float = 1200.0
export var trident_dash_distance: float = 150.0
var trident_dash_distance_left: float = 0.0

var acceleration: float = 4.8
var velocity: Vector2


var last_dir: Vector2

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
	match state:
		STATE.FREE:
			get_aim_dir()
			if Input.is_action_just_pressed(basic_attack_control):
				basic_attack()
			if Input.is_action_just_pressed(melee_attack_control) and not trident.attacking:
				trident.attack()
				state = STATE.CHARGING
		STATE.CHARGING:
			get_aim_dir()


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
			var move_vec = get_move_dir()
			velocity = velocity.linear_interpolate(move_vec,acceleration*delta)
			move_and_slide(velocity*speed)
		STATE.CHARGING:
			move_and_slide(velocity*speed)
			velocity = velocity.linear_interpolate(Vector2(),acceleration*delta)
		STATE.ATTACK_DASHING:
			move_and_slide(last_dir*trident_dash_speed)
			trident_dash_distance_left -= delta*trident_dash_speed

func get_move_dir():
	var h_move = Input.get_axis(move_left_control,move_right_control)
	var v_move = Input.get_axis(move_up_control,move_down_control)
	var move_vec = Vector2(h_move/2.0,v_move/2.0).normalized()
	return move_vec

func get_aim_dir():
	var h_dir = Input.get_axis(aim_left_control,aim_right_control)
	var v_dir = Input.get_axis(aim_up_control,aim_down_control)
	var dir = Vector2(h_dir/2.0,v_dir/2.0).normalized()
	if dir != Vector2():
		trident.rotation = dir.angle()
		last_dir = dir
	return dir

func basic_attack():
	var dir = get_aim_dir()
	if dir == Vector2():
		dir = last_dir
	var puc = load("res://characters/attacks/basic.tscn").instance()
	get_parent().add_child(puc)
	puc.global_position = global_position
	puc.direction = dir
	puc.player = player

func hit(damage: float):
	if frozen: return
	health -= damage
	if health <= 0:
		death()
	ui.update_ui(health)

func death():
	Global.emit_signal("gameover")
	var death_screen = preload("res://ui/gameover.tscn").instance()
	Global.add_child(death_screen)
	death_screen.set_message(name + " je pobedio :D")

func restart():
	frozen = false
	health = max_health
	ui.update_ui(health)

