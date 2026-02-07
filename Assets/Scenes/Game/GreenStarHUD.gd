extends AnimatedSprite

var got = false
onready var anim = $AnimationPlayer



func _on_GreenStar_get():
	anim.play("got")


func _on_GreenStar2_get():
	anim.play("got")
func _on_GreenStar3_get():
	anim.play("got")
