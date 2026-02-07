extends Area2D
@onready var audio = $AudioStreamPlayer2D
@onready var coll = $CollisionShape2D
@onready var poinlight = $PointLight2D
@onready var anim =$AnimationPlayer
@onready var sprite = $AnimatedSprite
@export var light = false
@export var state = STATE.COIN

enum STATE{
	COIN = 1,
	KEYCOIN = 2,
	TENCOIN = 3
}



func _process(delta):
	match state:
		STATE.COIN:
			sprite.play("coin")
		STATE.KEYCOIN:
			sprite.play("key_coin")
		STATE.TENCOIN:
			sprite.play("ten_coin")
	
	
	if light == true:
		poinlight.visible = true
	else:
		poinlight.visible = false
func _on_Coin_body_entered(body):
	match state:
		STATE.COIN:
			self.visible = false
			Globals.coin_number += 1
		STATE.KEYCOIN:
			anim.play("carry")
		STATE.TENCOIN:
			anim.play("carry")
			Globals.coin_number += 10
	coll.queue_free()
	audio.play()
	await get_tree().create_timer(0.6).timeout
	queue_free()


func _on_button_button_down():
	light = false
	self.visible = false
	coll.disabled = true
	Globals.coin_number += 1
	audio.play()
	await get_tree().create_timer(0.6).timeout
	queue_free()
