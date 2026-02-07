extends AnimatedSprite2D

@onready var anim = $AnimationPlayer
@onready var coin_audio = $CoinAudio
enum {
	COIN = 1,
	KEYCOIN = 2,
	TENCOIN = 3,
	THIRTYCOIN = 4,
	FIFTYCOIN = 5
}
var states = 1
var time = 0.55
var coin_number = 1
var key_coin_number = 1
func _ready():
	coin_audio.play()
	match states:
		COIN:
			self.play("coin")
			coin_number = 1
			key_coin_number  = 0
		KEYCOIN:
			self.play("keycoin")
			coin_number = 0
			key_coin_number = 1
		TENCOIN:
			self.play("tencoin")
			coin_number = 10
			key_coin_number = 0
	anim.play("hit")
	await get_tree().create_timer(time).timeout
	Globals.coin_number += coin_number
	queue_free()
