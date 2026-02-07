extends TileMap

@onready var anim = $AnimationPlayer

@onready var area_coll = $Area2D/CollisionShape2D



func _on_Area2D_body_entered(player):
	anim.play("enter")
	area_coll.queue_free()
