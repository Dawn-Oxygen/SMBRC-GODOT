extends CharacterBody2D


#enum  CHARACENTER{
	#MARIO = 1,#马里奥
	#LUIGI = 2
#}
enum {
	IDLE = 1,
	WALK = 2,
	RUN = 3,
	JUMP = 4,
	FALL = 5,
	BRAKE = 6,
	SQUAT = 7,
	SLIDE = 8,
	WALLJUMP = 9,
	DEAD  = 10,
	SIT = 11,
	AIRSPIN = 12
	
}
enum{
	SMALL = 1,
	SUPER = 2,
	FIRE = 3,
	ICE = 4,
	CLOUD = 5
}
enum{
	BENGIN = -1,
	DEFAUL = 0,
	CLEAR = 1,
	STAIC = 2
}


@onready var coll = $CollisionShape2D
@onready var hit = $Hitbox/CollisionShape2D
@onready var hurt = $Hurtbox/CollisionShape2D
@onready var small_jump_audio = $Audios/SmallJumpAudio
@onready var big_jump_audio = $Audios/BigJumpAudio
@onready var air_spin_audio = $Audios/AirSpinAudio
@onready var sit_spin_audio = $Audios/SitSpinAdudio
@onready var sit_audio = $Audios/SitAdudio
@onready var ceilting_audio = $Audios/CeilingAudio
@onready var hit_audio = $Audios/HitAudio
@onready var brake_audio = $Audios/BrakeAudio
@onready var hurt_audio = $Audios/HurtAudio
@onready var audios = $Audios
@onready var wudi_anim = $AnimationPlayer3
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite
@onready var left_ray = $WallCheck/Left
@onready var right_ray = $WallCheck/Right
@onready var prop_box = $PropBox


@export var state = 1 #状态
@export var character_index_file = preload("res://Assets/Character/Mario/mario.json")
@export var power_state_index_file = preload("res://Assets/PowerStates/Small/small.json")

##角色
var MAX_GRAVITY = 0
var gravity = 0
var walk_speed = 0
var run_speed = 0
var spin_jump_force = 0
var jump_force = 0
var floor_move_acc = 0
var run_to_walk_delta = 0
var stay_to_walk_delta = 0
var to_run_delta = 0
var sky_move_acc = 0
var sky_stay_acc = 0
var brake_acc = 0

var frames_path:String
var sprite_frames_string:String
var anim_library_path:String


##状态
var sprite_offset_x = 0
var sprite_offset_y = -7
var squat_sprite_offset_x =  0
var squat_sprite_offset_y = -7	
var coll_shape_size_x=10
var coll_shape_size_y=14
var squat_coll_shape_size_x=10
var squat_coll_shape_size_y=9
var coll_offset_x=0
var coll_offset_y=7
var squat_coll_offset_x=0
var squat_coll_offset_y=-4.5



var airsping = false
var is_spin_jumping = false
var is_jumping = false
var now_speed_h = 100
var gravity_acceleration = 0
var is_grounded = false
var direction = 0
var acceleration = 0
var airspin_cd_time = 0.8
var was_grounded = false
var is_brakeing = false
var is_ceiled = false
var wall_jump_direction = 0
var is_left_wall
var is_right_wall
var wudi_timer =3
var is_wudi = false
var is_in_enemy_hit_box = false
var is_death = false
var is_siting = false

var anim_state = 0
var death_wait_time = 3
var delta_phy = 0
var delta_n = 0
var clear_state = DEFAUL
var on_flag_time = 1.5
var on_flag_buttom_time = 1
var begin_walk_timer = 1
var air_spin_time = 0.15

var sit_roll_timer = 0.4
var sit_roll_time = 0.4
var sit_floor_time = 0.4
var sit_floor_timer = 0.4
var sit_audio_time = 0

var left_wall = false
var right_wall = false
var on_left = false
var on_right = false
var left_jump = false
var right_jump = false
var wall_jump_timer = 0
var wall_jump_time = 0.3
var wall_jump_force = 220
var wall_jump_timer_add_time = 0.0





signal dead
const death = preload("res://Assets/Scenes/Object/Player/PlayerDeath.tscn")
const hit_text = preload("res://Assets/Scenes/Object/Player/hit.tscn")

var death_inst = death.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
var hit_text_inst = hit_text.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)


func _ready():
	clear_state = BENGIN
func _physics_process(delta):
	match clear_state:
		DEFAUL:
			_gravity()
			_move()
		CLEAR:
			_gravity()
			if on_flag_time >= 0:
				anim.play("flag")
				anim.speed_scale = 0
				velocity = Vector2.ZERO
				on_flag_time -= delta
			if on_flag_time <= 0:
				velocity.y = 128
				anim.speed_scale = 1
			if is_on_floor():
				on_flag_buttom_time -= delta
				if on_flag_buttom_time <= 0:
					velocity.x = move_toward(velocity.x,100,5)
					anim.play("walk")
			if not is_on_floor() and on_flag_time <= 0 and on_flag_buttom_time <= 0:
				#anim.play("fall")
				pass
		BENGIN:
			_gravity()
			_state_anim()
			if begin_walk_timer>0:
				anim.play("walk")
				velocity.x = walk_speed
				begin_walk_timer -= delta
			if begin_walk_timer <=0:
				clear_state = DEFAUL
		STAIC:
			velocity = Vector2.ZERO
			now_speed_h = 0
	#_state()
	delta_phy = delta
	
func _input(event):
	if event.is_action_pressed("jump") and not is_siting and is_on_floor()and not clear_state == 4:
		if state == 1:
			small_jump_audio.play()
		else:
			big_jump_audio.play()
		is_jumping = true
		velocity.y = -(abs(velocity.x / 5)+jump_force)
		##跳跃
		
	if event.is_action_released("jump") and velocity.y < -jump_force / 4.5:
		is_jumping = false
		velocity.y = -jump_force / 4.5  - now_speed_h / 75
		gravity += 100
		
		
	if is_on_ceiling() and velocity.y <= 0:
		velocity.y = jump_force / 3
		
		
	if event.is_action_released("spin") and velocity.y < -jump_force / 3:
		velocity.y = -spin_jump_force / 3
		gravity = gravity * 1.5
		
	if event.is_action_pressed("spin") and is_grounded:
		is_spin_jumping = true
		velocity.y = -spin_jump_force
		
		
	if event.is_action_pressed("jump") and not is_on_floor() and ((on_left) or (left_wall and direction < 0)) and not anim_state == SIT:
		if wall_jump_timer_add_time == 0:
			wall_jump_timer = wall_jump_time
			wall_jump_timer_add_time += 1
		on_left = false
		left_jump = true
		gravity = 0
		is_jumping = true
		velocity.y = -wall_jump_force
		
		
		
	if event.is_action_pressed("jump") and not is_on_floor() and ((on_right) or (right_wall and direction > 0)) and not anim_state == SIT:
		if wall_jump_timer_add_time == 0:
			wall_jump_timer = wall_jump_time
			wall_jump_timer_add_time += 1
		on_right = false
		right_jump = true
		gravity = 0
		is_jumping = true
		velocity.y = -wall_jump_force
		
		
		
		
func _process(delta):
	
	if character_index_file.data is Dictionary:
		character(character_index_file.data)
	else:
		print("角色文件读取错误：非有效文件")
	if power_state_index_file.data is Dictionary:
		_power(power_state_index_file.data)
	else:
		print("状态文件读取错误：非有效文件")
	
	delta_n = delta
	if air_spin_time >= 0:
		air_spin_time -= delta
	if air_spin_time <= 0:
		airsping = false
	if airspin_cd_time >= 0:
		airspin_cd_time-= delta
		
	if is_on_floor():
		airspin_cd_time = 0
	match clear_state:
		DEFAUL:
			direction = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
			_skill()
			_check()
			_state_anim()
	if is_death:
		velocity = Vector2.ZERO
		
	if $Skill.is_firing == true:
		anim.play("fire")
	
func _on_Hitbox_hit():
	Globals.hit_nummber += 1
	hit_text_inst.position = self.global_position
	get_tree().root.get_node("Level1").get_node("Player").add_child(hit_text_inst)
	hit_text_inst = hit_text.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	hit_audio.play()
	gravity = 0
	if not is_siting:
		if Input.is_action_pressed("jump"):
			is_jumping = true
			if not velocity.x <= 0:
				velocity.y = -(jump_force + (velocity.x / 6))
			else:
				velocity.y = -(jump_force - (velocity.x / 6))
			
		else:
			velocity.y = -jump_force / 2
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 3:
			is_jumping = false
			velocity.y = -jump_force / 3  - now_speed_h / 70
			gravity = gravity * 1.2

func _check():
	left_wall = left_ray.is_colliding()
	right_wall = right_ray.is_colliding()
func _move():
	if not anim_state == WALLJUMP and not is_siting:
		if is_on_floor() and not anim_state == SQUAT:
			Globals.hit_nummber = 0
			velocity.x = move_toward(velocity.x,direction * now_speed_h,floor_move_acc)
		elif not anim_state == SQUAT:
			if not direction ==0:
				velocity.x = move_toward(velocity.x,direction * now_speed_h,sky_move_acc)
			else:
				velocity.x = move_toward(velocity.x,direction * now_speed_h,sky_stay_acc)
		elif anim_state == SQUAT:
			if not is_on_floor():
				velocity.x = move_toward(velocity.x,direction * now_speed_h,floor_move_acc)
			if is_on_floor():
				velocity.x = move_toward(velocity.x,0,5)
	if Input.is_action_pressed("run") and not direction == 0 and now_speed_h >= walk_speed:
		now_speed_h = move_toward(now_speed_h,run_speed,to_run_delta)
		
	if not Input.is_action_pressed("run") and now_speed_h > walk_speed and is_on_floor():
		now_speed_h = move_toward(now_speed_h,walk_speed,run_to_walk_delta)
		
	if now_speed_h < walk_speed and not direction == 0:
		now_speed_h = move_toward(now_speed_h,walk_speed,to_run_delta)
		
func _gravity():
	if not is_death:
		move_and_slide()
	if not anim_state == SLIDE and not is_siting and not velocity.y >= MAX_GRAVITY:
		velocity.y += gravity * (delta_phy*2.5)
	if not is_grounded and not anim_state==SLIDE and not is_siting and not gravity >= MAX_GRAVITY:
		gravity += (gravity/4.5 + 8)
func _death():
	emit_signal("dead")
	audios.PROCESS_MODE_WHEN_PAUSED
	self.PROCESS_MODE_PAUSABLE
	get_tree().paused = true
	visible = false
	is_death = true
	hit.disabled = true
	hurt.disabled = true
	death_inst.global_position = self.global_position
	get_tree().root.get_node("Level1").get_node("Player").add_child(death_inst)
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
func _skill():
	
	if left_jump:
		velocity.x = run_speed
		now_speed_h = run_speed
		direction = 1
	if is_on_floor() or wall_jump_timer <= 0:
		left_jump = false
		right_jump = false
	if wall_jump_timer >= 0:
		wall_jump_timer_add_time = 0
		wall_jump_timer -= delta_n
	if right_jump:
		velocity.x = -run_speed
		now_speed_h = run_speed
		direction = -1
	
	
	if is_wudi == true:
		hurt.disabled = true
		wudi_anim.play("wudi")
		if not wudi_timer <=0:
			wudi_timer -= delta_phy
		if wudi_timer <= 0:
			is_wudi = false
		
	elif not is_wudi and not is_death:
		wudi_timer = 3
		hurt.disabled = false
		wudi_anim.play("RESET")
		
	#if is_in_enemy_hit_box and not is_wudi:
		#if state == 2:
			#is_wudi = true
			#hurt_audio.play()
			#self.PROCESS_MODE_PAUSABLE
			#get_tree().paused = true
			#state = 1
			#await get_tree().create_timer(0.3).timeout
			#get_tree().paused = false
			#self.position.y += 10
		#elif state > 2 :
			#is_wudi = true
			#hurt_audio.play()
			#self.PROCESS_MODE_WHEN_PAUSED
			#get_tree().paused = true
			#state = 2
			#await get_tree().create_timer(0.3).timeout
			#get_tree().paused = false
			#
		#elif state == 1:
			#_death()

	
	
	if not was_grounded and is_grounded:
		gravity = 0
	if is_on_ceiling() and anim_state == JUMP:
		ceilting_audio.play()
		gravity += 100
	
	if is_grounded:
		is_jumping=false
		is_spin_jumping=false
	
	if is_on_floor():
		is_grounded = true
	else:
		is_grounded = false
	if is_grounded and not velocity.x==0 and now_speed_h < 100:
		anim_state = WALK
	if is_grounded and not velocity.x==0 and now_speed_h >= 100:
		anim_state = RUN
	if is_grounded and velocity.x==0:
		anim_state = IDLE
	if is_spin_jumping:
		anim.play("spin_jump")
	if Input.is_action_pressed("move_left") and velocity.x > walk_speed and is_on_floor() :
		anim_state = BRAKE


	if Input.is_action_pressed("move_right") and velocity.x < -walk_speed and is_on_floor() :
		anim_state = BRAKE
	if not is_on_floor() and velocity.y >= 0 and not on_left and not on_right and not airsping:
		anim_state = FALL
	if not is_on_floor() and velocity.y < 0 and not on_left and not on_right and not airsping and not anim_state == SQUAT:
		anim_state = JUMP
	
	if not airsping and Input.is_action_just_pressed("spin") and not is_on_floor() and not is_siting and not state == CLOUD and airspin_cd_time <= 0:
		air_spin_audio.play()
		airsping = true
		air_spin_time = 0.15
		airspin_cd_time = 0.5
	if airsping:
		anim_state = AIRSPIN
	if not is_siting:
		prop_box.set_monitorable(false)
	if not is_on_floor() and Input.is_action_just_pressed("down") and not is_siting:
		prop_box.set_monitorable(true)
		anim.play("sit")		
		sit_roll_timer = sit_roll_time
		sit_floor_timer = sit_floor_time
		sit_audio_time = 0
		sit_spin_audio.play()
		airsping = false
		is_jumping = false
		is_siting = true
	if sit_roll_timer >= 0:
		sit_roll_timer -= delta_n
	if is_siting == true:
		if sit_roll_timer > 0:
			velocity.y = -10
		if sit_roll_timer <= 0:
			velocity.y = 460
		anim_state = SIT
		if Input.is_action_just_pressed("up") and sit_roll_timer <= 0 and not is_on_floor():
			is_siting = false
	if is_on_floor() and is_siting:
		if sit_audio_time<=0:
			sit_audio.play()
			sit_audio_time+=1
		sit_floor_timer -= (delta_n * 2)
		if sit_floor_timer <= 0:
			is_siting = false
		if Input.is_action_just_pressed("jump"):
			is_siting = false
	if not is_on_floor() and not anim_state == SIT and is_on_wall() and not is_siting: 
		if left_wall and direction < 0 and not right_wall:
			on_left = true
		if right_wall and direction > 0 and not left_wall:
			on_right = true
	if on_left and not is_siting:
		anim_state = SLIDE
	if on_right and not is_siting:
		anim_state = SLIDE
	if is_on_floor():
		on_left = false
		on_right = false
	if on_left:
		if direction > 0 or not left_wall or is_siting:
			on_left = false
	if on_right:
		if direction < 0 or not right_wall or is_siting:
			on_right = false
	if Input.is_action_pressed("down") and not is_siting:
		anim_state = SQUAT
func _state_anim():
	if not $Skill.is_firing and not $Skill.is_sping:
		match anim_state:
			IDLE:
				anim.play("idle")
				anim.speed_scale= 1
			WALK:
				if not is_on_wall():
					anim.play("walk")
				if direction > 0 :
					sprite.flip_h = false	
				if direction < 0 :
					sprite.flip_h = true
				anim.speed_scale = (abs(velocity.x) * 0.02)
			RUN:
				if not is_on_wall():
					anim.play("walk")
				if direction > 0 :
					sprite.flip_h = false	
				if direction < 0 :
					sprite.flip_h = true
				anim.speed_scale = (abs(velocity.x) * 0.02)
			JUMP:
					anim.speed_scale = 1
					anim.play("jump")
					if direction > 0 :
						sprite.flip_h = false	
					if direction < 0 :
						sprite.flip_h = true
			BRAKE:
				brake_audio.play()
				anim.speed_scale = 1
				acceleration = now_speed_h / 40
				anim.play("brake")
				var brake_direction = -direction
				if -direction > 0 :
					sprite.flip_h = false	
				if -direction < 0 :
					sprite.flip_h = true
			FALL:
				
				anim.speed_scale = 1
				anim.play("fall")
				if direction > 0 :
					sprite.flip_h = false	
				if direction < 0 :
					sprite.flip_h = true
			SQUAT:
				anim.speed_scale = 1
				anim.play("squat")
			SLIDE:
				anim.speed_scale = 1
				anim.play("slide")
				if on_left:
					sprite.flip_h = false
				if on_right:
					sprite.flip_h = true
			WALLJUMP:
				anim.speed_scale = 1
				anim.play("jump")
			AIRSPIN:
				anim.play("airspin")
				anim.speed_scale = 1
				if velocity.y >= 0:
					gravity  /= 4
					velocity.y /=2.5		
			SIT:
				anim.speed_scale = 1
				velocity.x = 0
				now_speed_h = 0
	#match state:
		#SMALL:
			##coll.position = Vector2(0,-7)
			#hurt.scale = Vector2(1,1)
			#coll.scale = Vector2(1,1)
			#hit.position.y = 0
			#
			#sprite.play("Small")
			#sprite.offset.y = -7
		#SUPER:
			##coll.position = Vector2(0,0)
			#hurt.scale = Vector2(1,2)
			#coll.scale = Vector2(1,2.2)
			#hit.position.y = 12
			#
			#sprite.play("Super")
			#sprite.offset.y = -7
		#FIRE:
			##coll.position = Vector2(0,0)
			#hurt.scale = Vector2(1,2)
			#coll.scale = Vector2(1,2.2)
			#hit.position.y = 12
			#
			#sprite.play("Fireflower")
			#sprite.offset.y = -7	
		#ICE:
			##coll.position = Vector2(0,0)
			#hurt.scale = Vector2(1,2)
			#coll.scale = Vector2(1,2.2)
			#hit.position.y = 12
			#
			#sprite.play("Iceflower")
		#CLOUD:
			##coll.position = Vector2(0,0)
			#hurt.scale = Vector2(1,2)
			#coll.scale = Vector2(1,2.2)
			#hit.position.y = 10
			#sprite.play("CloudFlower")


func character(character_file:Dictionary):
	MAX_GRAVITY = character_file.script_variable.MAX_GRAVITY
	
	walk_speed = character_file.script_variable.walk_speed
	run_speed = character_file.script_variable.run_speed
	
	spin_jump_force = character_file.script_variable.spin_jump_force
	jump_force = character_file.script_variable.jump_force
	
	run_to_walk_delta = character_file.script_variable.run_to_walk_delta
	stay_to_walk_delta = character_file.script_variable.stay_to_walk_delta
	to_run_delta = character_file.script_variable.to_run_delta
	
	sky_move_acc = character_file.script_variable.sky_move_acc
	sky_stay_acc = character_file.script_variable.sky_stay_acc
	brake_acc = character_file.script_variable.brake_acc
	floor_move_acc = character_file.script_variable.floor_move_acc
	
	frames_path = character_file.file.sprite_frames
	
	sprite.sprite_frames = load(frames_path)

func _power(power_file:Dictionary):
	var sprite_offset_x = power_file.player_variable.sprite_offset_x
	var sprite_offset_y = power_file.player_variable.sprite_offset_y
	var squat_sprite_offset_x = power_file.player_variable.squat_sprite_offset_x
	var squat_sprite_offset_y = power_file.player_variable.squat_sprite_offset_y
	
	var coll_shape_size_x = power_file.player_variable.coll_shape_size_x
	var coll_shape_size_y = power_file.player_variable.coll_shape_size_y
	#var squat_coll_shape_size_x = power_file.player_variable.squat_coll_shape_size_x
	#var squat_coll_shape_size_y = power_file.player_variable.squat_coll_shape_size_y
	
	var coll_offset_x=power_file.player_variable.coll_offset_x
	var coll_offset_y=power_file.player_variable.coll_offset_y
	
	var squat_coll_offset_x=power_file.player_variable.squat_coll_offset_x
	var squat_coll_offset_y=power_file.player_variable.squat_coll_offset_y
	
	sprite.play(power_file.file.player_sprite_anim_string)



func _on_DeadBox_area_entered(area):
	_death()
	

#func _state():
	#if not anim_state == SQUAT:
		#sprite.scale = Vector2(1,1)
		#sprite.offset = Vector2(0,0)
	#match anim_state:
		#BRAKE:
			#now_speed_h = move_toward(now_speed_h,0,walk_speed)
			#velocity.x = move_toward(velocity.x,0,brake_acc)
		#FALL:
			#pass
		#SQUAT:
			#pass
		#SLIDE:
			#velocity.y = move_toward(velocity.y,60,20)
			#gravity = move_toward(gravity,50,15)
			#now_speed_h = 0
		#WALLJUMP:
			#velocity.x += run_speed * wall_jump_direction
		#SQUAT:
			#anim.play("squat")
			#print("1")
			#velocity.x = move_toward(velocity.x,0,brake_acc)
func _on_Hurtbox_area_entered(area):
	is_in_enemy_hit_box = true
func _on_Hurtbox_area_exited(area):
	is_in_enemy_hit_box = false
