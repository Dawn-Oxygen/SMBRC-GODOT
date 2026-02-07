extends Node2D

@onready var anim = $AnimationPlayer
var was_show = false
var show_time = 0
var time = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim.play("roll")
