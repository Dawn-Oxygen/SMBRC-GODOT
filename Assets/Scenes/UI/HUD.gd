extends CanvasLayer

@export var coin_number = 0
@export var key_coin_number = 0

@onready var label = $Control/CoinNumber

func _process(delta):
	if Globals.coin_number < 10:
		label.text = "0"+ str(Globals.coin_number)
	if Globals.coin_number >=10:
		label.text = str(Globals.coin_number)
