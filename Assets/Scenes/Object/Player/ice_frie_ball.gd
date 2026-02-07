extends CharacterBody2D

@onready var anim = $AnimationPlayer

var speed_scale = 1.0
var speed = 150
var jump_force = 150
var gravity = 500
var on_floor_timer = 0.5
var jump_timer = 0.5
var is_jumping = false
var hit = false
var ice_block = preload("res://Assets/Scenes/Object/Player/ice_block.tscn")
var ice_block_inst

func _ready():
	anim.play("roll")


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
	ice_block_inst = ice_block.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	if is_on_floor():
		on_floor_timer -= delta
		gravity = 0
		is_jumping = true
	if is_on_wall():
		_hit()


func _hit():
	hit = true
	anim.play("hit")
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_hit_box_area_entered(area):
	ice_block_inst.global_position = area.get_parent().global_position
	ice_block_inst.sprite_frames_res = area.get_parent().get_node("Sprite").sprite_frames
	area.get_parent().queue_free()
	get_tree().root.get_node("Level1").get_node("Enemies").add_child(ice_block_inst)
	_hit()
