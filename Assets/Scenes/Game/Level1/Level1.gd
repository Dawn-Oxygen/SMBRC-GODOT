extends Node2D

enum{
	ON = 1,
	OFF = -1
}
var on_off_block_state = ON
var coin_nuber
var health_number
@onready var color_rect_anim = $UIcolorRect/AnimationPlayer
@onready var bgm = $BGM

#func _process(delta):
	#if Input.is_action_pressed("maaove_down"):
		#get_window().size.x += 5
		#get_window().size.y += 5
	#else:
		#get_window().size.x -= 5
		#get_window().size.y -= 5
func _ready():
#	color_rect_anim.play("hide")#	color_rect_anim.play("hide")
#	get_tree().paused = true
#	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
func _color_rect_show():
	color_rect_anim.play("show")
func _color_rect_hide():
	color_rect_anim.play("hide")


func _on_Player_dead():
	bgm.stream_paused = true
	await get_tree().create_timer(2).timeout
	_color_rect_show()
	
