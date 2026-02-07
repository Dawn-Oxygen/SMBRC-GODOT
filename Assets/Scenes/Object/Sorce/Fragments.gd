extends Node2D

@onready var fragment_1 = $Fragment/AnimatedSprite
@onready var fragment_2 = $Fragment2/AnimatedSprite
@onready var fragment_3 = $Fragment3/AnimatedSprite
@onready var fragment_4 = $Fragment4/AnimatedSprite

@export var frames_1 = preload("res://Assets/Scenes/Object/Sorce/Fragment.tres")
@export var frames_2 = preload("res://Assets/Scenes/Object/Sorce/Fragment.tres") 
@export var frames_3 = preload("res://Assets/Scenes/Object/Sorce/Fragment.tres")
@export var frames_4 = preload("res://Assets/Scenes/Object/Sorce/Fragment.tres")   

func _process(delta):
	fragment_1.sprite_frames = frames_1
	fragment_2.sprite_frames = frames_2
	fragment_3.sprite_frames = frames_3
	fragment_4.sprite_frames = frames_4
	


