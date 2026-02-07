extends AnimatedSprite


@onready var anim = $AnimationPlayer
@export var state = 3
var state_prop = preload("res://Assets/Scenes/Object/Prop/StateProp.tscn")
@onready var inst = state_prop.instance()
var wait_time = 0.4
enum {
	SUPER = 2,
	FIREFLOWER = 3
}
func _process(delta):
	inst = state_prop.instance()
	inst.state = state
	inst.position = self.global_position
func _ready():
	match state:
		SUPER:
			self.play("mushroom")
		FIREFLOWER:
			self.play("fireflower")
	anim.play("hit")
	yield(get_tree().create_timer(wait_time),"timeout")
	get_tree().root.get_node("Level1").get_node("Prop").add_child(inst)
	queue_free()
