extends RigidBody2D

@export var h_speed = 1.0
@export var v_speed = 1.0

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite


func _ready():
	#sprite.sprite_frames = frames
	if h_speed > 0:
		anim.play("right_roll")
	elif h_speed < 0:
		anim.play("left_roll")
	linear_velocity.y = -300 * v_speed
	linear_velocity.x = 100 * h_speed
	await get_tree().create_timer(4).timeout
	queue_free()
func _process(delta):
	anim.speed_scale = abs(self.linear_velocity.y) * 0.02
