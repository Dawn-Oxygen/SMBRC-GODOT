extends CharacterBody2D

@onready var anim = $AnimationPlayer

var speed_scale = 1.0
var speed = 200
var jump_force = 100
var gravity = 500
var on_floor_timer = 0.5
var jump_timer = 0.5
var is_jumping = false
var hit = false



func _ready():
	anim.play("right_roll")


func _physics_process(delta):
	if not hit:
		move_and_slide()
	if hit:
		velocity = Vector2.ZERO
	velocity.y = gravity * delta
	
	gravity += 500
	
	if is_jumping:
		velocity.y -= jump_force
	velocity.x = speed_scale * speed
	
func _process(delta):
	
	if is_on_floor():
		on_floor_timer -= delta
		gravity = 0
		is_jumping = true
	if is_on_wall():
		_hit()


func _on_HitBox_area_entered(area):
	_hit()
func _hit():
	hit = true
	anim.play("hit")
	await get_tree().create_timer(0.2).timeout
	queue_free()
