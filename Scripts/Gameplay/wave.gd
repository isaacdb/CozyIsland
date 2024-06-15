extends Sprite2D


func _ready():
	var _start_pos = global_position
	
	var tween = create_tween().set_loops()
	tween.tween_property(self, "global_position:x", global_position.x + 30, 3.5)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position:x", global_position.x - 30, 3.5)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pass # Replace with function body.
