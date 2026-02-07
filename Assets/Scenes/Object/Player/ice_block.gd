extends CharacterBody2D

@onready var enemy_sprite = $EnemySprite
var sprite_frames_res

func _ready():
	print("ceate")
func _process(delta):
	enemy_sprite.sprite_frames = sprite_frames_res
