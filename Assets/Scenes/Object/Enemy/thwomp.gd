extends "res://Assets/Scenes/Object/Enemy/Enemy.gd"

@onready var check = $CheckPlayer
@onready var primary_position = self.position
@onready var hit_audio = $HitAudio

@export var falling_speed = 50
@export var rising_speed = 1
var is_falling = false
var is_rising = false
var static_time = 1
var static_timer= static_time
var hit_audio_time = 0

func _physics_process(delta):
	move_and_slide()
func _process(delta):
	_recall(delta)
	_anim()
	if is_falling:
		_falling(delta)
	elif is_rising:
		_rising(delta)
		hit_audio_time = 0
	if is_on_floor():
		static_timer -= delta
		is_falling = false
		hit_audio_time += 1
	else:
		static_timer = static_time
	if static_timer <= 0:
		is_rising = true
	if is_rising:
		check.monitoring = false
	else:
		check.monitoring = true
	
	if hit_audio_time == 0 and is_on_floor():
		hit_audio.play()


func _on_check_player_body_entered(body):
	is_falling = true

func _falling(delta):
	velocity.y += falling_speed
func _rising(delta):
	position.y = move_toward(position.y,primary_position.y,rising_speed)
func _recall(delta):
	if (is_rising and position.y == primary_position.y) or is_on_ceiling():
		primary_position = self.position
		velocity.y = 0
		is_rising = false
		#如果你看见我的鼠标在这里转圈发呆 那就说明我健忘症又犯了
func _anim():
	if is_rising:
		sprite.frame = 0
	elif is_falling or is_on_floor():
		sprite.frame = 2
	else:
		sprite.frame = 1
