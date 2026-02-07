extends Node2D

@onready var plantform_position = $Position2D
var gravity = 0
var was_under_player = false

func _physics_process(delta):
	plantform_position.position = Vector2(plantform_position.position.x,plantform_position.position.y+gravity)
	if was_under_player == true:
		gravity = move_toward(gravity,4,0.05)
		
		


func _on_Area2D_body_entered(body):
	was_under_player = true
