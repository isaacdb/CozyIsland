extends Area2D

signal dettach
signal attach

@export var rotate_on_start := true

@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var audio_stream = $AudioStreamPlayer2D as AudioStreamPlayer2D

var _drag_in_slot_clip = preload("res://Sounds/drag_in_slot.ogg") as AudioStream
var _rotate_clip = preload("res://Sounds/rotate.ogg") as AudioStream
var _hover_clip = preload("res://Sounds/hover.ogg") as AudioStream
var _drag_clip = preload("res://Sounds/click.ogg") as AudioStream
var _drop_wrong_clip = preload("res://Sounds/wrong_slot.ogg") as AudioStream


var _list_slots : Array[DropItem]
var _original_scale : Vector2
var _scale_hover : Vector2
var _scale_click : Vector2
var _draggable := false
var _is_dragging := false
var _rotation_aux := 0
var _mouse_smoth := false
var _position_click : Vector2
var _level_completed := false
var _safe_area : SafeArea

func _ready():
	for child in get_children():
		if child is DropItem:
			_list_slots.append(child)
			
	Global.level_complete.connect(func(): _level_completed = true)
	
	_safe_area = get_tree().get_first_node_in_group('SafeArea') as SafeArea
	
	_original_scale = sprite_2d.scale
	_scale_hover = sprite_2d.scale * 1.1
	_scale_click = sprite_2d.scale * 0.9
	
	mouse_entered.connect(_on_area_2d_mouse_entered)
	mouse_exited.connect(_on_area_2d_mouse_exited)	
	
	audio_stream.volume_db = 0
	audio_stream.bus = "Sound"
	move_to_start_rand_pos()
	pass

func move_to_start_rand_pos():
	move_to_safe_area()
	if rotate_on_start:
		_rotation_aux = randi_range(0, 4)
		rotate_aux("up")
	pass

func _process(delta):
	if _level_completed:
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
	pass
	
func check_release_click() -> void:
	if not _is_dragging:
		return
	
	if GeneralSettingsManager.mobile:
		_is_dragging = false
		if (_position_click - get_global_mouse_position()).length() < 10:
			rotate_aux("up")
			await get_tree().create_timer(0.3).timeout
		pass
	else:
		if (_position_click - get_global_mouse_position()).length() < 10:
			return
		pass
	
	_is_dragging = false
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
	
func get_item() -> void:
	z_index = 10
	_position_click = get_global_mouse_position()
	dettach.emit()
	var _tween_boing = get_tree().create_tween()
	_tween_boing.tween_property(sprite_2d, "scale", _scale_click, 0.1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween_boing.tween_property(sprite_2d, "scale", _scale_hover, 0.1)\
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
		
	if Input.is_action_just_pressed("scroll_up"):
		rotate_aux("up")
	if Input.is_action_just_pressed("scroll_down"):
		rotate_aux("down")
	if Input.is_action_just_pressed("right_click"):
		rotate_aux("down")
	pass
	
func drop_item() -> void:
	z_index = 5
	Global.is_dragging = false
	var is_over_item = check_over_item()
	if is_over_item:
		move_to_safe_area()
		return
	var moved_to_slot = move_to_firt_slot()
	if not moved_to_slot:
		var is_over_area_droppable = check_over_area_droppable()
		if is_over_area_droppable:
			move_to_safe_area()
			return
	pass

func rotate_aux(scroll: String):
	if scroll == "up":
		_rotation_aux += 1
	else:
		_rotation_aux -= 1
	
	if _rotation_aux >= 4: _rotation_aux = 0
	
	var _tween_rotate = get_tree().create_tween()
	_tween_rotate.tween_property(self, "rotation_degrees", _rotation_aux * 90, 0.2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	play_sound(_rotate_clip)
	pass

func move_to_safe_area():
	play_sound(_drop_wrong_clip)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", _safe_area.get_rand_position(), 0.5)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	pass

func check_over_item() -> bool:
	for item in _list_slots:
		if item.is_on_item():
			return true
	return false
	
func check_over_area_droppable() -> bool:
	for item in _list_slots:
		if item.is_on_droppable_area():
			return true
	return false

func move_to_firt_slot() -> bool:
	for item in _list_slots:
		if item.is_on_slot():
			item.move_to_slot()
			play_sound(_drag_in_slot_clip)
			return true
	return false
	
func play_sound(clip: AudioStream):
	audio_stream.stream = clip
	audio_stream.play()
	pass	

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		_draggable = true
		tween_scale_sprite(_scale_hover)
		play_sound(_hover_clip)
	pass

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		_draggable = false
		tween_scale_sprite(_original_scale)
	if Global.is_dragging and not _is_dragging:
		_draggable = false
		tween_scale_sprite(_original_scale)
	pass
	
func tween_scale_sprite(scale_tween: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", scale_tween, 0.1).set_ease(Tween.EASE_OUT)
	pass
