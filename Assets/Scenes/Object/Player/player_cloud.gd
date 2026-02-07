extends CharacterBody2D

@onready var anim = $AnimationPlayer

var timer = 5

func _ready():
	anim.play("show")
func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
	if timer <= 2:
		anim.play("shine")
