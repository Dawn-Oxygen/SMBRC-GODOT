extends KinematicBody2D

var knockback = Vector2.ZERO
onready var stats = $Stats

export var acceleration = 300
export var max_speed = 50
export var friction = 200
onready var lookforbox = $Lookfor_box
onready var anim = $AnimationPlayer
enum  {
	IDLE = 1,
	WANDER = 2,
	CHASE = 3,
}

var state = IDLE

var have_player

var velocity = Vector2()



func _on_hurt_box_hurt():
	
	#var knockback_vector = area.knockback_vector
	#knockback = knockback_vector*120
	stats.health -= 1
	if stats.health <=0:
		queue_free()
	print(stats.health)
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			anim.play("down_idle")
			velocity = velocity.move_toward(Vector2.ZERO,100 *delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			anim.play("down_move")
			var player = lookforbox.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed,acceleration*delta)
			else:
				state = IDLE
	velocity = move_and_slide(velocity)
func seek_player():
	if lookforbox.can_see_player():
		state = CHASE
