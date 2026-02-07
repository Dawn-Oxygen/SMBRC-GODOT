extends "res://Assets/Scenes/Object/Enemy/Enemy.gd"

enum MODE {
	FALL = 0,
	STATIC = 1,
}#这里是表示 冰锥的模式 一个是可以下落的 另一个是不可以下落
enum STATE{
	STATIC = 0,
	DIE = 1,
	FALL = 2
}
var state = STATE.STATIC
@export var mode = STATE.STATIC

@onready var primary_position = self.position #获取初始位置
@onready var collison = $CollisionShape2D
@onready var fragments = $Fragments

var reset_time = 3
var reset_timer = reset_time
var check = false
var falling_speed = 200
var static_time = 1
var static_timer = static_time

var fragment



#本人技术不行 看个乐就好（

func _ready():
	can_gravity = false
	visible = true
func _process(delta):
	_disable_check()
	print(static_timer)
	match state:
		STATE.STATIC:
			velocity.y = 0
		STATE.DIE:
			dead = true
			velocity.y = 0
			collison.disabled = true
			visible = false
			#print(reset_timer)
			reset_timer -= delta
			#sprite.offset.y = -37
			#sprite.scale = Vector2(0.5,0.3)
		STATE.FALL:
			if velocity.y < falling_speed:
				velocity.y += 5
			else:
				velocity.y = falling_speed
	match mode:
		MODE.FALL:
			if check and state == STATE.STATIC:
				static_timer -= delta
				#state = STATE.FALL
			if static_timer < static_time:
				static_timer -= delta
			if state == STATE.STATIC and static_timer <= 0:
				state = STATE.FALL
	if reset_timer <= 0:
		_reset()
	if is_on_floor():
		state = STATE.DIE
func _physics_process(delta):
	move_and_slide()
	
func _reset():
	collison.disabled = false
	state = STATE.STATIC
	position = primary_position
	anim.play("reset")
	visible = true
	reset_timer = reset_time
	static_timer = static_time
	dead = false
func _on_hit_box_area_entered(area):
	state = STATE.DIE
func _anim():
	match mode:
		MODE.STATIC:
			sprite.play("static")
		MODE.FALL:
			sprite.play("fall")


func _on_check_player_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	check = true


func _on_check_player_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	check = false
