extends Area2D

@export_file var level

var is_player_enter = false

@onready var dialog_box = $DialogBox

@onready var label = $DialogBox/Label

@onready var anim = $DialogBox/AnimationPlayer



@export var text = "new"

var Player

func _ready():
	dialog_box.visible = false
 
func _process(delta):
	if is_player_enter and Input.is_action_just_pressed("jump"):
		get_tree().root.get_node("Map")._color_rect_show()
		get_tree().paused = true
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file(level)
		get_tree().paused = false
	label.text = text

func _on_Level_body_entered(player):
	is_player_enter = true
	dialog_box.visible = true
	anim.play("enter")
	
	


func _on_Level_body_exited(player):
	is_player_enter = false
	anim.play("exit")
	await get_tree().create_timer(0.5).timeout
	dialog_box.visible = false
