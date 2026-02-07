extends CharacterBody2D

enum Direction {LEFT = -1,RIGHT = 1}

@onready var anim = $AnimationPlayer
@onready var hurt = $HurtBox
@onready var hit = $HitBox
@onready var anim2 = $AnimationPlayer2
@onready var hit_coll = $HitBox/CollisionShape2D
@onready var fire_hit_coll = $HitBox2/CollisionShape2D
@onready var hurt_coll = $HurtBox/CollisionShape2D
@onready var o_hurt = $OtherHurtBox
@onready var sprite = $Sprite
@onready var death_audio = $Sprite

@export var move_speed = 40
@export var can_move = true
@export var can_gravity = true
@export var death_sprite_frames = preload("res://Assets/Scenes/Object/Enemy/Goomba.tres")


const death = preload("res://Assets/Scenes/Object/Enemy/EnemyDeath.tscn")
var inst_death = death.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)

var click_time = 2
var gravity = 100
var direction = Direction.LEFT
var pro_delta
var dead = false
var coll_wall_time = 0


func _process(delta):
	pro_delta = delta
func _gravity():
	if can_gravity:
		velocity.y += gravity
	if is_on_floor():
		gravity = 0
	else:
		gravity += 40
	
func _death():
	dead = true
	can_gravity = false
	move_speed = 0
	death_audio.play()
	anim.play("death")
	await get_tree().create_timer(1).timeout
	queue_free()
	
	
func _disable_check():
	if dead:
		hurt.monitorable = false
		hurt.monitoring = false
		hit.monitorable = false
		hit.monitorable = false
		o_hurt.monitorable = false
		o_hurt.monitoring = false
	else:
		hurt.monitorable = true
		hurt.monitoring = true
		hit.monitorable = true
		hit.monitorable = true
		o_hurt.monitorable = true
		o_hurt.monitoring = true
func _direction_change():
	if is_on_wall() and is_zero_approx(coll_wall_time):
		direction *= -1
		coll_wall_time +=1
		print(direction)
	if not is_on_wall():
		coll_wall_time = 0
func _special_death():
	dead = true
	inst_death.frames = death_sprite_frames
	can_gravity = false
	death_audio.play()
	anim.play("hit")
	inst_death.global_position = self.global_position
	visible = false
	anim.play("death")
	get_tree().root.get_node("Level1").get_node("Enemies").add_child(inst_death)
	await get_tree().create_timer(1).timeout
	queue_free()
func _change_sprite_direction():
	if direction == Direction.LEFT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
