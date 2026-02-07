extends Area2D

@export var is_hiting = false
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@export var thing = preload("res://Assets/Scenes/Object/Coin/HitCoin.tscn")
var inst = thing.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
@export var prop_state = 1
var Player
@export var number = 10
var state = DEFAUT
var time = 0.1
var player_in = false
var self_altitude
enum {
	DEFAUT = 1,
	NOT = -1
}
func _ready():
	pass
func _process(delta):
	if number <= 0:
		state = NOT
	match state:
		DEFAUT:
			sprite.play("default")
		NOT:
			sprite.play("not")
	
	if player_in == true:
		if not is_hiting and state == 1 and Player.altitude == 1:
			Player.altitude = 0
			inst = thing.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			inst.states = prop_state
			inst.position.x = self.position.x
			inst.position.y = self.position.y - 64
			anim.play("hit")
			await get_tree().create_timer(time).timeout
			number -= 1
			get_tree().root.get_node("Map").get_node("Objects").get_node("Prop").add_child(inst)
	
	
func _on_button_button_down():
	if  not is_hiting and state == 1:
		inst = thing.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		inst.states = prop_state
		inst.position.x = self.position.x
		inst.position.y = self.position.y - 64
		anim.play("hit")
		await get_tree().create_timer(time).timeout
		number -= 1
		get_tree().root.get_node("Map").get_node("World").add_child(inst)



func _on_body_entered(player):
	player.modulate = Color(0.5,0.5,0.5,1)
	player_in = true
	Player = player


func _on_body_exited(player):
	player_in = false
	player.modulate = Color(1,1,1,1)
