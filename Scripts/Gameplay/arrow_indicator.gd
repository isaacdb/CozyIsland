extends Label

@export var position_1 : Marker2D
@export var position_2 : Marker2D
@export var intensity : float

var _tween_pointing : Tween
var _point_to_square := false

func _ready():
	tween_pointing("x")
	pass

func _process(delta):
	if not _point_to_square and Global.is_dragging:
		_point_to_square = true
		_tween_pointing.kill()
		_tween_pointing = null
		var tween_move = self.create_tween()
		tween_move.tween_property(self, "position", position_2.position, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_move.parallel().tween_property(self, "rotation_degrees", 270, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_move.tween_callback(tween_pointing.bind("y"))
	pass
	
func tween_pointing(axis: String) -> void:
	var mid_pos = position.x if axis == "x" else position.y
	
	if _tween_pointing == null:
		_tween_pointing = self.create_tween().set_loops()
	
	_tween_pointing.tween_property(self, "position:"+axis, mid_pos + intensity, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_tween_pointing.tween_property(self, "position:"+axis, mid_pos - intensity, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pass


