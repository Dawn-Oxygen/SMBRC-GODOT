extends Button

var mouse_in = false
var MAX_SCALE = Vector2(0.33,0.33)
var low_scale = Vector2(0.3,0.3)
var add = Vector2.ZERO
var press = false
@export var once_press = true
var disable_time = 0.5
var disable_timer = disable_time
var was_show = false
var show_time = 0.2
var show_timer = show_time
@export var press_color = Color(1,1,1,1)
@onready var level_panel: Panel = $"../../LevelPanel"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if was_show:
		show_timer -= delta
	if get_parent().visible==true and not was_show:
		$AnimationPlayer.play("show")
		was_show = true
	if get_parent().visible==false:
		show_timer = show_time
		modulate = Color(1,1,1,0)
		was_show = false
	add.x = scale.x * delta
	add.y = scale.y* delta
	if mouse_in == true:
		scale.x = move_toward(scale.x,MAX_SCALE.x,add.x)
		scale.y = move_toward(scale.y,MAX_SCALE.y,add.y)
	if mouse_in == false and press == false :
		scale.x = move_toward(scale.x,low_scale.x,add.x)
		scale.y = move_toward(scale.y,low_scale.y,add.y)
	if disable_timer <= 0:
		press = false
		disabled = false
		if show_timer<=0:
			modulate = Color(1,1,1,1)
	if press and not once_press:
		disable_timer -= delta


func _on_mouse_entered():
	mouse_in = true


func _on_mouse_exited():
	mouse_in = false


func _on_button_down():
	disable_timer = disable_time
	press = true
	disabled = true
	$AnimationPlayer.play("press")
	level_panel.show()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Game/Levels/World1/level_1.tscn")



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Game/Levels/World1/light.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Game/textlevel/ghosttscn.tscn")
	


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Game/textlevel/test.tscn")
