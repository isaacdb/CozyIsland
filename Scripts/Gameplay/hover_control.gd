extends Button

@onready var audio_stream = $AudioStreamPlayer2D as AudioStreamPlayer2D

var _hover_clip = preload("res://Sounds/hover.ogg") as AudioStream
var _original_scale : Vector2
var _hover_scale : Vector2
var _click_scale : Vector2

func _ready():
	_original_scale = scale
	_hover_scale = scale * 1.1
	_click_scale = scale * 0.6
	audio_stream.stream = _hover_clip
	audio_stream.bus = "Sound"
	
	mouse_entered.connect(Callable(on_hover_button_next).bind(true))
	mouse_exited.connect(Callable(on_hover_button_next).bind(false))
	pressed.connect(on_pressed)
	pass

func on_pressed():
	audio_stream.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", _click_scale, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", _hover_scale, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	pass

func on_hover_button_next(is_on_hover: bool) -> void:
	var tween = get_tree().create_tween()
	if is_on_hover:
		audio_stream.play()
		tween.tween_property(self, "scale", _hover_scale , 0.1).set_ease(Tween.EASE_OUT)
	else: 
		tween.tween_property(self, "scale", _original_scale, 0.1).set_ease(Tween.EASE_OUT)
	pass
