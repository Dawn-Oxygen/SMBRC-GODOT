extends CharacterBody2D



@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var point_light = $PointLight2D
@onready var break_audio = $BreakAudio
@onready var top_hit_coll = $Top/CollisionShape2D
@onready var down_hit_coll = $Down/CollisionShape2D
@onready var coll = $CollisionShape2D
@export var fragments_frame = 0
@export var is_hiting = false
@export var thing = preload("res://Assets/Scenes/Object/Coin/HitCoin.tscn")
@export var prop_state = 2
@export var number = 1
@export var state = BLOCKSTATE.DEFAUT
@export var number_state = NUMBERSTATE.WITHOUTPROP
@export var can_top_work = true
@export var can_down_work = true
@export var can_break = false
var time = 0.2
var direction = UP
var check_up = false
var check_down = false
var area_up = false
var area_down = false
var in_area_down_num = 0
var prop_area
signal up
const fragments = preload("res://Assets/Scenes/Object/Sorce/Fragments.tscn")
var fragments_inst = fragments.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
var inst = thing.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
enum BLOCKSTATE {
	DEFAUT = 1,
	NORMAL = -1
}
enum {
	UP = -1,
	DOWN = 1
}
enum NUMBERSTATE {
	PROP = 0,
	WITHOUTNUM = 1,
	WITHOUTPROP = 2
}
func _ready():
	pass
#func _process(delta):
	#_check()
	#_other()
	
func _other():
	if number <= 0:
		state = BLOCKSTATE.NORMAL
	match state:
		BLOCKSTATE.DEFAUT:
			sprite.play("default")
		BLOCKSTATE.NORMAL:
			sprite.play("normal")
	#if check_down:
		#_top_work()
	fragments_inst.position = self.position
	


func _on_button_button_down():
	if  not is_hiting and state == 1:
		#_top_work()
		is_hiting = true
		
func _prop():
	if not is_hiting and not state == BLOCKSTATE.NORMAL and in_area_down_num == 0:
		in_area_down_num += 1
		if not number_state == NUMBERSTATE.WITHOUTPROP:
			direction = UP
			inst = thing.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			inst.states = prop_state
			inst.position.x = self.global_position.x
			inst.position.y = self.global_position.y - 16.1
			anim.play("down")
			await get_tree().create_timer(0.1).timeout
			match number_state:
				NUMBERSTATE.PROP:
					number -= 1
				NUMBERSTATE.WITHOUTNUM:
					pass
			get_tree().root.get_node("Level1").get_node("Prop").add_child(inst)
			is_hiting = false
			await get_tree().create_timer(0.2).timeout
			in_area_down_num = 0
func _break():
	await get_tree().create_timer(0.1).timeout
	inst.global_position = self.global_position
	break_audio.play()
	visible = false
	top_hit_coll.disabled = true
	down_hit_coll.disabled = true
	coll.disabled = true
	get_tree().root.get_node("Level1").get_node("Map").get_node("Blocks").add_child(fragments_inst)
	await get_tree().create_timer(3).timeout
	queue_free()
func _check():
	if is_hiting == false and area_down:
		check_down = true
	else:
		check_down = false
	if is_hiting == false and area_up:
		check_up = true
	else:
		check_up = false
func _without_prop_top_work():
	anim.play("down")

func _on_down_body_exited(body):
	area_down = false
	in_area_down_num = 0
	
	


func _on_down_body_entered(body):
	if body.velocity.y <= 100 and in_area_down_num==0:
		
		area_down = true
	else:
		area_down = false



func _on_top_area_entered(area: Area2D) -> void:
	if can_top_work:
		_prop()


func _on_top_area_exited(area: Area2D) -> void:
	pass
