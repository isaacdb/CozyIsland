extends Control

@export var intensity := 10.0

var _start_pos : Vector2

func _ready():
	_start_pos = position
	
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", _start_pos.y + intensity, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", _start_pos.y - intensity, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pass

