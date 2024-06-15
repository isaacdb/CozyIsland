extends StaticBody2D
class_name DropSlot

@onready var sprite_2d = $Sprite2D as Sprite2D

var _is_on_hover := false
var _original_scale : Vector2
var _hover_scale : Vector2

func _ready():
	_original_scale = sprite_2d.scale
	_hover_scale = sprite_2d.scale * 1.1
	sprite_2d.scale = Vector2.ZERO
	sprite_2d.visible = false
	var tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.tween_property(sprite_2d, "visible", true, 0)
	tween.tween_property(sprite_2d, "scale", _original_scale, 1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).from(Vector2.ZERO)
	
func on_hover(is_on_hover: bool) -> void:
	_is_on_hover = is_on_hover
	var tween = get_tree().create_tween()
	if is_on_hover:
		tween.tween_property(sprite_2d, "scale", _hover_scale, 0.1).set_ease(Tween.EASE_OUT)
	else: 
		tween.tween_property(sprite_2d, "scale", _original_scale, 0.1).set_ease(Tween.EASE_OUT)
	pass
	
func is_on_hover() -> bool: return _is_on_hover
