extends Sprite2D

@export var item_name : String

var _final_pos := Vector2(-880, 464)

func _ready():
	
	visible = false
	Global.level_complete.connect(collect)
	scale = Vector2.ZERO
	z_index = 100
	global_position = Vector2(0, 800)
	pass

func collect():
	var avaiable = Global.list_itens_avaiable.any(func(i): return i == item_name)
	if avaiable: return
	
	visible = true
	Global.list_itens_avaiable.append(item_name)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(0, 200), 1)
	tween.parallel().tween_property(self, "scale", Vector2(1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.5)
	tween.tween_property(self, "global_position", _final_pos, 1)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
