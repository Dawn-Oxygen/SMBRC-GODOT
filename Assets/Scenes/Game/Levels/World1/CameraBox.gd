extends Area2D

@export var camera_scale = Vector2(2.3,2.3)
@export var scale_delta = Vector2(0.05,0.05)

@export var offset = Vector2(0,0)
@export var offset_delta = Vector2(20,20)

@export var smoothing_speed = 6
@export var camera_limit_1 = Vector2.ZERO
@export var camera_limit_2 = Vector2(99999,-99999)
@export var camera_smooth = true
@export var camera_limit_smooting = false
