extends Node2D

@onready var door_1 = $Door1
@onready var door_2 = $Door2
@onready var door_1_anim = $Door1/AnimationPlayer
@onready var door_2_anim = $Door2/AnimationPlayer
@onready var ui_color_rect = get_tree().root.get_node("Level1").get_node("UIcolorRect").get_node("AnimationPlayer")

@export var door1_can_move = true
@export var door2_can_move = true

var in_door1 = false
var in_door2 = false
var player_floor:bool
var player_node:Node
var is_moving = false



func _ready():
	pass 

func _process(delta):
	player_floor = get_tree().root.get_node("Level1").get_node("Player").get_node("Player").is_on_floor()
	if (in_door1 or in_door2) and player_floor and is_moving == false:
		if in_door1 and door1_can_move:
			if Input.is_action_pressed("up"):
				is_moving = true
				player_node.clear_state = 4
				player_node.velocity = Vector2.ZERO
				player_node.now_speed_h = 0
				player_node.gravity = 0
				player_node.sprite.frame = 0
				ui_color_rect.play("show")
				door_1_anim.play("open")
				door_2_anim.play("open")
				await get_tree().create_timer(1).timeout
				player_node.global_position = door_2.global_position
				await get_tree().create_timer(0.2).timeout
				ui_color_rect.play("hide")
				player_node.clear_state = 0
				is_moving = false
		if in_door2 and door2_can_move:
			if Input.is_action_pressed("up"):
				is_moving = true
				player_node.clear_state = 4
				player_node.velocity = Vector2.ZERO
				player_node.now_speed_h = 0
				player_node.gravity = 0
				player_node.sprite.frame = 0
				ui_color_rect.play("show")
				door_2_anim.play("open")
				door_1_anim.play("open")
				await get_tree().create_timer(1).timeout
				player_node.global_position = door_1.global_position
				await get_tree().create_timer(0.2).timeout
				ui_color_rect.play("hide")
				player_node.clear_state = 0
				is_moving = false
			
func _on_door_1_body_entered(player):
	player_node = player
	in_door1 = true
	

func _on_door_1_body_exited(player):
	in_door1 = false	


func _on_door_2_body_entered(player):
	player_node = player
	in_door2 = true


func _on_door_2_body_exited(player):
	in_door2 =false
