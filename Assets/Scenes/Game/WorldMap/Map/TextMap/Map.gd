extends Node2D


@onready var color_rect_anim = $UIColorRect/AnimationPlayer

func _ready():
	color_rect_anim.play("hide")
func _color_rect_show():
	color_rect_anim.play("show")
func _color_rect_hide():
	color_rect_anim.play("hide")
