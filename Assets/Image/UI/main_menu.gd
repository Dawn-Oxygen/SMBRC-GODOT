extends Node2D

@onready var menu_back_groud = $MenuBackGround
@onready var setting_menu = $SettingMenu
@onready var filer = $Filer
@onready var black_out = $BlackOut

var hide_time = 1
var hide_timer = hide_time
var hide = true

# Called when the node enters the scene tree for the first time.
func _ready():
	filer.visible = false
	black_out.visible = false
	setting_menu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hide:
		hide_timer -= delta
	if hide_timer <= 0 and hide:
		filer.visible = false
		black_out.visible = false
		setting_menu.visible = false

func _on_button_4_button_down():
	hide_timer = hide_time
	hide = false
	filer.visible = true
	black_out.visible = true
	setting_menu.visible = true
	setting_menu.get_node("ColorRect/AnimationPlayer").play("show")
	setting_menu.get_node("Label/AnimationPlayer").play("show")


func _on_button_button_down():
	hide = true
	setting_menu.get_node("ColorRect/AnimationPlayer").play("hide")
	setting_menu.get_node("Label/AnimationPlayer").play("hide")
