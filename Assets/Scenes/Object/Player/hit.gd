extends AnimatedSprite2D

var state = 0
var finish_rotation 
var queue_time = 4
var visible_time = 2

@onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("show")
	frame = Globals.hit_nummber - 1
	finish_rotation = RandomNumberGenerator.new().randf_range(-0.3,0.3)
	print(finish_rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(Globals.hit_nummber)
	visible_time -= delta
	queue_time -= delta
	if visible_time <= 0:
		anim.play("hide")
	if queue_time <= 0:
		queue_free()
	self.rotation = move_toward(self.rotation,finish_rotation,abs(finish_rotation/10))
#	if Input.is_action_just_pressed("jump"):
#		get_tree().reload_current_scene()
