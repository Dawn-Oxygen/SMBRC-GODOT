extends "res://Assets/Scenes/Object/Sorce/block.gd"

func _process(delta):
	_check()
	_other()
	if check_down:
		_prop()
