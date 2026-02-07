extends Area2D


@onready var anim = $AnimationPlayer
signal get

func _ready():
	anim.play("float")

func _on_GreenStar_body_entered(body):
	emit_signal("get")
	anim.play("get")
	await get_tree().create_timer(0.6).timeout
	queue_free()
