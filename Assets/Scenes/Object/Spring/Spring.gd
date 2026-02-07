extends KinematicBody2D

var velocity = Vector2.ZERO

var gravity = 0

var time = 0.01

onready var anim  = $AnimationPlayer
onready var pos  = $PosBody

func _physics_process(delta):
	move_and_slide(velocity)
	velocity.y = gravity * delta
func _process(delta):
	if is_on_floor():
		gravity = 0
	if not is_on_floor():
		gravity += 400


func _on_Area2D_body_entered(body):
	anim.play("spring")
	body.velocity.x / 50
	yield(get_tree().create_timer(time),"timeout")
	body.gravity = 0
	body.velocity.y -= 800
