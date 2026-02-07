extends CharacterBody2D

enum {
	SUPER = 2,
	FIREFLOWER = 3,
	ICEFLOWER = 4,
	CLOUDFLOWER = 5
}
@export var states = 2
@export var hit_state = 1
@onready var sprite = $AnimatedSprite
@onready var anim = $AnimationPlayer
@onready var area_coll = $Area2D/CollisionShape2D
@onready var powerUP = $PowerUP
@onready var hit_audio = $HitAudio


var fall_animation_is_overed = false
var can_play_fall_animation = true
var is_playing_fall_animation = false


enum {
	NORMAL = 1,
	HIT = 2
}
var gravity = 1000
var move_speed = 80
var time = 0.65
enum Direction{
	LEFT = -1,
	RIGHT = 1
}



var direction = Direction.RIGHT
func _physics_process(delta):
	if not is_on_floor():
		gravity +=400
func _ready():
	match hit_state:
		HIT:
			sprite.offset = Vector2(0,15)
			sprite.scale = Vector2(0.6,0.6)
			hit_audio.play()
			anim.play("hit")
	match states:
		SUPER:
			sprite.play("mushroom")
		FIREFLOWER:
			sprite.play("fireflower")
		ICEFLOWER:
			sprite.play("iceflower")

func _process(delta):
	
	
	match hit_state:
		HIT:
			anim.play("hit")
			await get_tree().create_timer(time).timeout
			hit_state = NORMAL
		NORMAL:
			var was_on_wall = is_on_wall()
			move_and_slide()
			if is_on_floor() == false:
				can_play_fall_animation = true
				sprite.scale.x = move_toward(sprite.scale.x,0.8,gravity * 0.000001)
				sprite.scale.y = move_toward(sprite.scale.y,1.1,gravity * 0.000001)
			if is_on_floor() == true:
				if can_play_fall_animation == true:
					is_playing_fall_animation = true
					can_play_fall_animation = false
				if is_playing_fall_animation:
					sprite.scale = Vector2(1.2,0.8)
					sprite.offset = Vector2(0,2)
					await get_tree().create_timer(0.1).timeout
					#sprite.scale.x = move_toward(sprite.scale.x,1.2,sprite.scale.x * 0.1)
					#sprite.scale.y = move_toward(sprite.scale.y,0.8,sprite.scale.y * 0.1)
					is_playing_fall_animation = false
				if sprite.scale.x == 1.2 and sprite.scale.y == 0.8:
					is_playing_fall_animation = false
				if not is_playing_fall_animation:
					sprite.scale.x = move_toward(sprite.scale.x,1,0.01)
					sprite.scale.y = move_toward(sprite.scale.y,1,0.01)
					sprite.offset.x = move_toward(sprite.offset.x,0,0.1)
					sprite.offset.y = move_toward(sprite.offset.y,0,0.1)
			
				
			match states:
				SUPER:
					velocity.y = gravity * delta
					if is_on_floor():
						gravity = 1000
						velocity.x = direction * move_speed
					if is_on_wall() and not was_on_wall:
						direction *= -1
				FIREFLOWER:
					velocity.y = gravity * delta
					if is_on_floor():
						gravity = 1000
				ICEFLOWER:
					velocity.y = gravity * delta
					if is_on_floor():
						gravity = 1000
				CLOUDFLOWER:
					velocity.y = gravity * delta
					if is_on_floor():
						gravity = 1000
					
					
			


func _on_Area2D_body_entered(player):
	powerUP.play()
	if (player.state >= 2 and states == 2) or (player.state == states):
		self.visible = false
		await get_tree().create_timer(0.85).timeout
		queue_free()
	else:
		player.get_node("AnimationPlayer2").play("state")
		if player.state == 1:
			player.position.y -= 10
		player.state = states
		await get_tree().create_timer(0.001).timeout
		visible = false
		get_tree().paused = true
		await get_tree().create_timer(0.85).timeout
		get_tree().paused = false
		queue_free()
	
