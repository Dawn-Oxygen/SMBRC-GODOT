extends "res://Assets/Scenes/Object/Enemy/Enemy.gd"

func _process(delta):
	_gravity()
	_direction_change()
	_disable_check()
	_change_sprite_direction()
	velocity.x = direction * move_speed
	
func _physics_process(delta):
	move_and_slide()

func _on_other_hurt_box_area_entered(area):
	_special_death()
