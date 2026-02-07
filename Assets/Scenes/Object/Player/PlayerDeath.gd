extends RigidBody2D


@onready var anim = $AnimationPlayer
@onready var death_audio = $DeathAudio

var velocity = Vector2.ZERO

func _ready():
	death_audio.play()
	anim.play("death")
	linear_velocity.y = -500
