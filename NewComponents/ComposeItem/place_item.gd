extends Area2D
class_name PlaceItem
 
@export var item_name : String

@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var audio_stream = $AudioStreamPlayer2D as AudioStreamPlayer2D

var _drag_in_slot_clip = preload("res://Sounds/drag_in_slot.ogg") as AudioStream
var _rotate_clip = preload("res://Sounds/rotate.ogg") as AudioStream
var _hover_clip = preload("res://Sounds/hover.ogg") as AudioStream
var _drag_clip = preload("res://Sounds/click.ogg") as AudioStream
var _drop_wrong_clip = preload("res://Sounds/wrong_slot.ogg") as AudioStream

var _original_scale_sprite : Vector2
var _scale_hover_sprite : Vector2
var _scale_click_sprite : Vector2
var _scale_original : Vector2
var _scale_min : Vector2
var _scale_max : Vector2
var _draggable := false
var _is_dragging := false
var _rotation_aux := 0
var _mouse_smoth := false
var _position_click : Vector2
var _over_thrash := false
var _original_sprite_pos : Vector2
var _tween_thrash : Tween
var _is_deleting := false

func _ready():
	add_to_group('Item')
	_original_scale_sprite = sprite_2d.scale
	_scale_hover_sprite = sprite_2d.scale * 1.1
	_scale_click_sprite = sprite_2d.scale * 0.9
	
	_scale_original = scale
	_scale_max = scale * 1.5
	_scale_min = scale * 0.5
	
	_original_sprite_pos = sprite_2d.position
	
	mouse_entered.connect(_on_area_2d_mouse_entered)
	mouse_exited.connect(_on_area_2d_mouse_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	audio_stream.volume_db = 0
	audio_stream.bus = "Sound"
	pass

func _process(delta):
	if _is_deleting:
		return
		
	if _draggable:
		if Input.is_action_just_pressed("click"):
			check_click()
			pass
			
		if Input.is_action_just_released("click"):
			check_release_click()
			pass
		
		if _is_dragging:
			drag_item(delta)
			
		if Input.is_action_just_pressed("right_click"):
			if z_index >= 5:
				z_index -= 1
				play_sound(_hover_clip)
			pass
	pass

func over_thrash_anim():
	if _over_thrash and (not _tween_thrash or not _tween_thrash.is_running()):
		_tween_thrash = get_tree().create_tween()
		_tween_thrash.set_loops()
		_tween_thrash.tween_property(sprite_2d, "position:x", _original_sprite_pos.x + 20, 0.1)
		_tween_thrash.tween_property(sprite_2d, "position:x", _original_sprite_pos.x - 20, 0.1)
		_tween_thrash.play()
	elif not _over_thrash and _tween_thrash and _tween_thrash.is_running():
		_tween_thrash.stop()
		sprite_2d.position = _original_sprite_pos
	pass

func new_instance():
	_draggable = true
	_is_dragging = true
	_mouse_smoth = false
	_position_click = get_global_mouse_position()
	Global.is_dragging = true
	pass
	
func check_release_click() -> void:
	if not _is_dragging:
		return
	
	if GeneralSettingsManager.mobile:
		_is_dragging = false
		if (_position_click - get_global_mouse_position()).length() < 10:
			rotate_aux("up")
		pass
	else:
		if (_position_click - get_global_mouse_position()).length() < 10:
			return
		pass
		
	drop_item()
	pass
	
func check_click() -> void:
	if Global.is_dragging: return 
	
	_is_dragging = not _is_dragging
	if _is_dragging:
		play_sound(_drag_clip)
		get_item()
	else:
		drop_item()
		pass

func drop_item() -> void:
	play_sound(_hover_clip)
	z_index = 10
	Global.is_dragging = false
	_is_dragging = false
	
	if _over_thrash:
		_is_deleting = true
		tween_delete()
	pass
		
func get_item() -> void:
	z_index = 11
	_position_click = get_global_mouse_position()
	var _tween_boing = get_tree().create_tween()
	_tween_boing.tween_property(sprite_2d, "scale", _scale_click_sprite, 0.1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween_boing.tween_property(sprite_2d, "scale", _scale_hover_sprite, 0.1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	Global.is_dragging = true
	_mouse_smoth = true
	pass
	
func drag_item(_delta) -> void:
	if (get_global_mouse_position() - global_position).length() < 50:
		_mouse_smoth = false
	
	if _mouse_smoth:
		var direcao = (get_global_mouse_position() - global_position).normalized()
		var movimento = direcao * 1500 * _delta
		global_position += movimento
	else:
		global_position = get_global_mouse_position()
	
	if Input.is_action_pressed("control"):
		if Input.is_action_just_pressed("scroll_up"):
			scale_aux('up')
			pass
		if Input.is_action_just_pressed("scroll_down"):
			scale_aux('down')
			pass
	elif Input.is_action_just_pressed("scroll_up"):
		rotate_aux("up")
	elif Input.is_action_just_pressed("scroll_down"):
		rotate_aux("down")
	elif Input.is_action_just_pressed("right_click"):
		rotate_aux("down")
	pass

func rotate_aux(scroll: String):
	if scroll == "up":
		_rotation_aux += 1
	else:
		_rotation_aux -= 1
	
	if _rotation_aux >= 20: _rotation_aux = 0
	
	var _tween_rotate = get_tree().create_tween()
	_tween_rotate.tween_property(self, "rotation_degrees", _rotation_aux * 18, 0.2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	play_sound(_rotate_clip)
	pass
	
func scale_aux(direction: String):
	var scale_add := _scale_original * 0.1
	if direction == 'up':
		scale_add *= 1
		if scale.length() >= _scale_max.length():
			return
		pass
	else:
		if scale.length() <= _scale_min.length():
			return
		scale_add *= (-1)
		pass
	play_sound(_rotate_clip)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", scale + scale_add, 0.1).set_ease(Tween.EASE_OUT)
	pass
	
func play_sound(clip: AudioStream):
	audio_stream.stream = clip
	audio_stream.play()
	pass	

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		_draggable = true
		tween_scale_sprite(_scale_hover_sprite)
		play_sound(_hover_clip)
	pass

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		_draggable = false
		tween_scale_sprite(_original_scale_sprite)
	pass
	
func tween_scale_sprite(scale_tween: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", scale_tween, 0.1).set_ease(Tween.EASE_OUT)
	pass
	
func tween_delete():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(self, "rotation_degrees", rotation_degrees + 360, 0.5)
	tween.tween_callback(func(): queue_free())
	pass
	
func _on_area_entered(area):
	if area.is_in_group('Thrash'):
		_over_thrash = true
		over_thrash_anim()
		pass
func _on_area_exited(area):
	if area.is_in_group('Thrash'):
		_over_thrash = false
		over_thrash_anim()
	pass
	
func generate_data() -> PlaceItemData:
	var data = PlaceItemData.new()
	data.global_position = self.global_position
	data.item_name = item_name
	data.rotation_degrees = rotation_degrees
	data.scale = scale
	return data
