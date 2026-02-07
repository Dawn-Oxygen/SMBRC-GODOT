extends Node2D

@onready var BoxA = $BoxA
@onready var BoxAanim = $BoxA/AnimationPlayer

@onready var BoxB = $BoxB
@onready var BoxBanim = $BoxB/AnimationPlayer

@onready var BoxAPos = BoxA.global_position
@onready var BoxBPos = BoxB.global_position

@export var BoxA_was_triggered = false
@export var BoxB_was_triggered = false

var wait_time = 0.15

func _ready():
	BoxAanim.play("idle")
	BoxBanim.play("idle")


func _on_BoxA_body_entered(player):
	BoxAanim.play("trigger")
	BoxB.monitoring = false
	player.velocity = Vector2.ZERO
	player.visible = false
	await get_tree().create_timer(wait_time).timeout
	player.set_position(BoxBPos)
	BoxBanim.play("trigger")
	BoxA.queue_free()
	await get_tree().create_timer(wait_time).timeout
	player.visible = true
	BoxB.queue_free()
func _on_BoxB_body_entered(player):
	BoxBanim.play("trigger")
	BoxA.monitoring = false
	player.velocity = Vector2.ZERO
	player.visible = false
	await get_tree().create_timer(wait_time).timeout
	player.set_position(BoxAPos)
	BoxAanim.play("trigger")
	BoxB.queue_free()
	await get_tree().create_timer(wait_time).timeout
	player.visible = true
	BoxA.queue_free()

