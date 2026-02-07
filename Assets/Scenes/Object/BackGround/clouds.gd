extends ParallaxLayer

@onready var anim = $AnimationPlayer

func _process(delta):
	anim.play("float")
