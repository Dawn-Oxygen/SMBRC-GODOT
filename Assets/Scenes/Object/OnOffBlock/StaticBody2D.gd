extends StaticBody2D


var state = 1
enum{
	ON = 1,
	OFF = -1
}
@onready var sprite = $AnimatedSprite
@onready var coll = $CollisionShape2D

func _process(delta):
	state = get_tree().root.get_node("Level1").on_off_block_state
	match state:
		ON:
			sprite.play("ON")
			coll.disabled = true
		OFF:
			sprite.play("OFF")
			coll.disabled = false
