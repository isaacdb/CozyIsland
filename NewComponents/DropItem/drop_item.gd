extends Area2D
class_name DropItem

signal attach

var _is_on_droppable_slot := false
var _is_on_droppable_area := false
var _is_on_item := false
var _body_ref : DropSlot
var _parent

func _init():
	add_to_group("item")
	pass

func _ready():
	await self.get_parent().ready
	_parent = self.get_parent()
	
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	pass

func move_to_slot() -> void:
	var _offset = _parent.global_position - global_position
	var tween = get_tree().create_tween()
	if _body_ref && _body_ref.is_on_hover():
		tween.tween_property(_parent, "global_position", _body_ref.global_position + _offset, 0.2)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
		attach.emit()
		Global.attach_item.emit()	
	pass
	
func is_on_slot() -> bool: return _is_on_droppable_slot	
func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable'):
		body.on_hover(true)
		_body_ref = body
		_is_on_droppable_slot = true
	pass
func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		body.on_hover(false)
		body = null
		_is_on_droppable_slot = false
	pass

func is_on_item() -> bool: return _is_on_item
func is_on_droppable_area() -> bool: return _is_on_droppable_area
func _on_area_entered(area):
	if area.is_in_group('item'):
		_is_on_item = true
	if area.is_in_group('droppable_area'):
		_is_on_droppable_area = true
	pass
func _on_area_exited(area):
	if area.is_in_group('item'):
		_is_on_item = false
	if area.is_in_group('droppable_area'):
		_is_on_droppable_area = false
	pass 
