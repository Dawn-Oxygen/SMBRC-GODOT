extends "res://Assets/Scenes/Object/Sorce/block.gd"

var on_off_state = 1

enum{
	ON = 1,
	OFF = -1
}

func _process(delta):
	on_off_state = get_tree().root.get_node("Level1").on_off_block_state
	_check()
	_anim_play()
	if check_down and in_area_down_num == 0 and not is_hiting:
		_switch()
func _anim_play():
	match on_off_state:
		ON:
			sprite.play("on")
		OFF:
			sprite.play("off")
func _switch():
	in_area_down_num += 1
	get_tree().root.get_node("Level1").on_off_block_state *= -1
	anim.play("down")
	is_hiting = false
	await get_tree().create_timer(0.2).timeout
	in_area_down_num == 0
