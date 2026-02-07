extends Area2D

@export var player_position_add = Vector2.ZERO


func _on_body_entered(player):
	player.global_position.x += player_position_add.x
	player.global_position.y+= player_position_add.y
