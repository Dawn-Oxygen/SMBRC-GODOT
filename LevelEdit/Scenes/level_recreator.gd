extends Node2D

@onready var camera = $Camera2D

@export var zoom_delta = 0.05
@export var MAX_CAMERA_SPEED = 25
@export var min_camera_speed = 10

var camera_speed = min_camera_speed
var camera_move_direction = Vector2.ZERO

func _process(delta):
	_direction()
	_camera_act()
	
func _direction():
	camera_move_direction.x = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	camera_move_direction.y = Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")
func _camera_act():
	if Input.is_action_just_pressed("edit_up"):
		camera.zoom.x += zoom_delta
		camera.zoom.y += zoom_delta
	if Input.is_action_just_pressed("edit_down"):
		camera.zoom.x -= zoom_delta
		camera.zoom.y -= zoom_delta
	camera.position.x += (camera_speed * camera_move_direction.x / (camera.zoom.x * 5))
	camera.position.y += (camera_speed * camera_move_direction.y / (camera.zoom.y * 5))
