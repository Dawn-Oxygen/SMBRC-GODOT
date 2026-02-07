extends Camera2D

@export var camera_zoom = Vector2.ZERO
@export var camera_zoom_delta = Vector2.ZERO
@export var camera_offset = Vector2.ZERO
@export var camera_smoothing_speed = 6
@export var camera_offset_delta = Vector2.ZERO
@export var camera_limit_1 = Vector2(0,640)
@export var camera_limit_2 = Vector2(99999,-99999)
@export var limit_smooting = false

func _ready():
	camera_zoom = self.zoom
	self.position_smoothing_enabled = false
	await get_tree().create_timer(0.5).timeout
	self.position_smoothing_enabled = true
	self.position = Vector2.ZERO
	self.limit_smooting = false
func _process(delta):
	self.zoom.y = move_toward(self.zoom.y,camera_zoom.y,camera_zoom_delta.y)
	self.zoom.x = move_toward(self.zoom.x,camera_zoom.x,camera_zoom_delta.x)
	self.limit_smoothed = limit_smooting
	self.position_smoothing_speed = camera_smoothing_speed
	
	self.offset.x = move_toward(self.offset.x,camera_offset.x,camera_offset_delta.x)
	self.offset.y = move_toward(self.offset.y,camera_offset.y,camera_offset_delta.y)
	self.limit_left = camera_limit_1.x
	self.limit_bottom = camera_limit_1.y
	self.limit_top = camera_limit_2.y
	self.limit_right = camera_limit_2.x

func _on_camera_box_area_entered(camera_box):
	camera_zoom_delta = camera_box.scale_delta
	camera_zoom = camera_box.camera_scale
	camera_smoothing_speed = camera_box.smoothing_speed
	camera_offset = camera_box.offset
	camera_offset_delta = camera_box.offset_delta
	camera_limit_1 = camera_box.camera_limit_1
	camera_limit_2 = camera_box.camera_limit_2
	limit_smooting = camera_box.camera_limit_smooting
	self.position_smoothing_enabled = camera_box.camera_smooth
