extends CharacterBody2D


enum Direction {LEFT = -1,RIGHT = 1}
var click_time = 2
var gravity = 0
@export var move_speed = 40
var direction = Direction.LEFT

const death = preload("res://Assets/Scenes/Object/Enemy/EnemyDeath.tscn")

var inst_death = death.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)

const enemy = 1

@onready var anim = $AnimationPlayer
@onready var hurt = $Hurtbox/CollisionShape2D
@onready var hit = $Hitbox/CollisionShape2D
@onready var anim2 = $AnimationPlayer2
@onready var sprite = $Sprite
@export var die = false
func _ready():
	die = false

func _process(delta):
	if direction < 0:
		sprite.flip_h = false
	if direction > 0:
		sprite.flip_h = true
	if die == true:
		queue_free()
	var was_on_wall = is_on_wall()
	move_and_slide()
	velocity.y = gravity * delta
	if is_on_floor():
		gravity = 0
	
	velocity.x = direction * move_speed
	if is_on_wall() and not was_on_wall:
		direction *= -1
func _physics_process(delta):
	if not is_on_floor():
		gravity +=400

func _on_hurtbox_area_entered(player):
	if player.get_parent().anim_state == 11:
		$DeadAudio.play()
		inst_death.global_position = self.global_position
		visible = false
		hit.queue_free()
		hurt.queue_free()
		get_tree().root.get_node("Level1").get_node("Enemies").add_child(inst_death)
		await get_tree().create_timer(0.3).timeout
		queue_free()
	else:
		move_speed = 0	
		hit.queue_free()
		hurt.queue_free()
		anim.play("death")
	
	



func _on_Hitbox2_area_entered(area):
	$Hitbox2/CollisionShape2D.disabled = true
	$DeadAudio.play()
	anim.play("hit")
	inst_death.global_position = self.global_position
	visible = false
	hit.disabled = true
	hurt.disabled = true
	get_tree().root.get_node("Level1").get_node("Enemies").add_child(inst_death)
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_button_button_down():
	if click_time <= 0:
		#$DeadAudio.play()
		inst_death.global_position = self.global_position
		visible = false
		hit.disabled = true
		hurt.disabled = true
		get_tree().root.get_node("Level1").get_node("Enemies").add_child(inst_death)
		await get_tree().create_timer(0.3).timeout
		queue_free()
	anim2.play("hit")
	print("click")
	click_time -= 1
