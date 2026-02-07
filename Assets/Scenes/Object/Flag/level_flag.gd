extends Node2D

@onready var bowser_flag = $BowserFlag
@onready var player_flag = $PlayerFlag
@onready var bottom = $Bottom

@onready var bowser_flag_goal_pos = player_flag.global_position
@onready var player_flag_goal_pos = bowser_flag.global_position

var bowser_flag_speed = 0
var player_flag_speed = 0



var bowser_flag_visible_time = 1.5

func _process(delta):
	bowser_flag.global_position.y = move_toward(bowser_flag.global_position.y,bowser_flag_goal_pos.y,-bowser_flag_speed)
	player_flag.global_position.y = move_toward(player_flag.global_position.y,player_flag_goal_pos.y,-player_flag_speed)
	if bowser_flag.global_position.y == bottom.global_position.y-12:
		bowser_flag_visible_time -= delta
	if bowser_flag_visible_time <= 0:
		bowser_flag.visible = false
func _on_flag_pole_body_entered(player):
	player_flag.global_position.y = player.global_position.y
	player_flag.visible = true
	player.sprite.flip_h = false
	player.global_position.x = self.global_position.x - 2
	player.clear_state = 1
	await get_tree().create_timer(1.5).timeout
	bowser_flag_speed = (-(bottom.global_position.y)-player.global_position.y)/1000
	player_flag_speed = (-(bottom.global_position.y)-player.global_position.y)/1000
