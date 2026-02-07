extends StaticBody2D

@onready var anim = $AnimationPlayer
var under_th = false

func _process(delta):
	pass
		#anim.play("pause")


func _on_Area2D_body_entered(body):
	anim.play("wobble")
