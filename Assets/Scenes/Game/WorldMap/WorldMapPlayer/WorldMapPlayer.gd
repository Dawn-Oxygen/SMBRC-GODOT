extends CharacterBody2D

@export var walk_speed = 60

@export var run_speed = 100

var now_speed = 60

var direction = Vector2.ZERO

@export var altitude = 0

@onready var anim = $AnimationPlayer

var Direction = 1

var acceleration = walk_speed/7.5

enum {
	UP = -1,
	DOWN = 1,
	LEFT = -2,
	RIGHT = 2
}

var anim_state = 1
@export var is_jumping = false

enum {
	IDLE = 1,
	MOVE = 2,
	JUMP = 3,
	ENTERLEVEL = 4
}

func _process(delta):
	direction.x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	direction.y = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("up")
	if is_jumping:
		anim_state = JUMP
	if not altitude ==0:
		is_jumping = true
	if direction.x > 0:
		Direction = RIGHT
	if direction.x < 0:
		Direction = LEFT
	if direction.y > 0:
		Direction = DOWN
	if direction.y < 0:
		Direction = UP
	
	
	match anim_state:
		IDLE:
			if not is_jumping:
				match Direction:
					UP:
						anim.play("idle_up")
					DOWN:
						anim.play("idle_down")
					LEFT:
						anim.play("idle_left")
					RIGHT:
						anim.play("idle_right")
		MOVE:
			if not is_jumping:
				match Direction:
					UP:
						anim.play("move_up")
						anim.speed_scale = abs(velocity.y) * 0.025
					DOWN:
						anim.play("move_down")
						anim.speed_scale = abs(velocity.y) * 0.025
					LEFT:
						anim.play("move_left")
						anim.speed_scale = abs(velocity.x) * 0.025
					RIGHT:
						anim.play("move_right")
						anim.speed_scale = abs(velocity.x) * 0.025
		JUMP:
			anim.speed_scale = 1
			#match Direction:
				#UP:
					#anim.play("jump_up")
				#DOWN:
					#anim.play("jump_down")
				#LEFT:
					#anim.play("jump_left")
				#RIGHT:
					#anim.play("jump_right")
func _physics_process(delta):
	move_and_slide()
	
	velocity.x = move_toward(velocity.x,now_speed*direction.x,acceleration)
	velocity.y = move_toward(velocity.y,now_speed*direction.y,acceleration)
	
	if velocity == Vector2.ZERO:
		anim_state = IDLE
	
	if Input.is_action_pressed("run") and not direction == Vector2.ZERO:
		now_speed = move_toward(now_speed,run_speed,acceleration)
	elif not Input.is_action_pressed("run"):
		now_speed = move_toward(now_speed,walk_speed,acceleration)
	
	if not velocity == Vector2.ZERO and not is_jumping:
		anim_state = MOVE
func _input(event):
	if event.is_action_pressed("jump") and not is_jumping:
		is_jumping = true
		match Direction:
			UP:
				anim.play("jump_up")
			DOWN:
				anim.play("jump_down")
			LEFT:
				anim.play("jump_left")
			RIGHT:
				anim.play("jump_right")
