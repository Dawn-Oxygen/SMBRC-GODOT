extends Node2D

enum {
	SHRINK = 0,
	OUT = 1
}

@onready var flower = $Flower
@onready var pos_a = $PositionA
@onready var pos_b = $PositionB

var stay_timer = 0
var stay_time = 2
var shrink_timer = 0
var shrink_time = 3
var speed = 1.5
var state = SHRINK
var player_in = false

func _process(delta):
	match state:
		SHRINK:
			stay_timer = stay_time
			shrink_timer -= delta
			if shrink_timer <= 0:
				flower.global_position.x = move_toward(flower.global_position.x,pos_a.global_position.x,speed)
				flower.global_position.y = move_toward(flower.global_position.y,pos_a.global_position.y,speed)
			if flower.global_position == pos_a.global_position:
				state = OUT
		OUT:
			shrink_timer = shrink_time
			stay_timer -= delta
			if stay_timer <= 0:
				flower.global_position.x = move_toward(flower.global_position.x,pos_b.global_position.x,speed)
				flower.global_position.y = move_toward(flower.global_position.y,pos_b.global_position.y,speed)
				if flower.global_position == pos_b.global_position and not player_in:
					state = SHRINK


func _on_area_2d_body_entered(area):
	player_in = true


func _on_area_2d_body_exited(body):
	player_in = false
