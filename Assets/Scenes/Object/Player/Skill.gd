extends Node2D

var fire_timer = 1.5
var state = 1
var fire_direciton
var fire_number = 2
var fire_keep_timer = 0.05
var spin_time = 0.4
var spin_timer = 0
var cloud_cd_timer = 5
var cloud_number = 2

@onready var fire_audio = $FireAudio

enum {
	SUPER = 2,
	FIRE = 3,
	ICE = 4,
	CLOUD = 5
}


var fire_ball = preload("res://Assets/Scenes/Object/Player/FireBall.tscn")
var ice_ball = preload("res://Assets/Scenes/Object/Player/ice_frie_ball.tscn")
var cloud = preload("res://Assets/Scenes/Object/Player/player_cloud.tscn")
var cloud_inst
var fire_ball_inst
var ice_ball_inst


@export var is_firing = false
@export var is_sping = false


func _process(delta):
	state = get_parent().state
	
	if get_parent().is_wudi == false and get_parent().is_in_enemy_hit_box:
		is_sping = false
	
	if get_parent().sprite.flip_h == false:
		fire_direciton = 1
	elif get_parent().sprite.flip_h == true:
		fire_direciton = -1
	
	if fire_keep_timer > 0 and is_firing:
		fire_keep_timer -= delta
	if fire_keep_timer <= 0:
		is_firing = false
	
	match state:
		FIRE:
			if not fire_timer <= 0:
				fire_timer -= delta
			if fire_timer <= 0:
				fire_number = 2
			if Input.is_action_just_pressed("run") and get_parent().is_siting == false:
				if fire_number > 0:
					fire_ball_inst = fire_ball.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
					fire_keep_timer = 0.25
					is_firing = true
					get_parent().anim.play("fire")
					fire_audio.play()
					fire_timer = 1.5
					fire_number -= 1
					if fire_direciton == 1:
						fire_ball_inst.speed_scale = 1.0 + abs(get_parent().velocity.x) * 0.005
					if fire_direciton == -1:
						fire_ball_inst.speed_scale = -1.0 - abs(get_parent().velocity.x) * 0.005
				
					fire_ball_inst.global_position = self.global_position
					get_tree().root.get_node("Level1").get_node("Player").add_child(fire_ball_inst)
		ICE:
			if not fire_timer <= 0:
				fire_timer -= delta
			if fire_timer <= 0:
				fire_number = 2
			if Input.is_action_just_pressed("run") and get_parent().is_siting == false:
				if fire_number > 0:
					ice_ball_inst = ice_ball.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
					fire_keep_timer = 0.05
					is_firing = true
					get_parent().anim.play("fire")
					fire_audio.play()
					fire_timer = 1.5
					fire_number -= 1
					if fire_direciton == 1:
						ice_ball_inst.speed_scale = 1.0 + abs(get_parent().velocity.x) * 0.005
					if fire_direciton == -1:
						ice_ball_inst.speed_scale = -1.0 - abs(get_parent().velocity.x) * 0.005
				
					ice_ball_inst.global_position = self.global_position
					get_tree().root.get_node("Level1").get_node("Player").add_child(ice_ball_inst)
		CLOUD:
			if not cloud_cd_timer <= 0:
				cloud_cd_timer -= delta
			if cloud_cd_timer <=0:
				if cloud_number <= 0:
					cloud_number = 2
					cloud_cd_timer = 8
			if not spin_timer <= 0:
				spin_time -= delta
			if spin_timer <= 0 or get_parent().is_on_floor():
				is_sping = false
			if Input.is_action_just_pressed("spin") and not get_parent().is_on_floor() and not get_parent().is_siting and not cloud_number <=0:
				cloud_inst = cloud.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
				cloud_number -=1
				is_sping = true
				spin_timer = spin_time
				get_parent().gravity = 0
				get_parent().velocity.y = -150
				get_parent().velocity.x /= 4
				get_parent().now_speed_h /=4
				get_parent().gravity = 0
				get_parent().anim.play("airspin")
				cloud_inst.position.y = get_parent().position.y + 6
				cloud_inst.position.x = get_parent().position.x
				get_tree().root.get_node("Level1").get_node("Player").add_child(cloud_inst)
