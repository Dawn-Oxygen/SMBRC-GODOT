extends "res://Assets/Scenes/Object/Enemy/Enemy.gd"

enum STATE {
	NOMAL = 0,
	SHRINK = 1,
	ROOL = 2
}
@export var state = STATE.NOMAL

func _process(delta):
	match state:
		STATE.NOMAL:
			sprite.play("Move")
			sprite.offset = Vector2(0,0)
		STATE.SHRINK:
			sprite.play("Shrink")
			sprite.offset = Vector2(0,5)
		STATE.ROOL:
			sprite.play("Roll")
			sprite.offset = Vector2(0,5)
