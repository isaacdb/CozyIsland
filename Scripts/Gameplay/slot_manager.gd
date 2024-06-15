extends Node2D

@onready var audio_stream = $AudioStreamPlayer2D as AudioStreamPlayer2D

var _list_slots : Array[DropItem]
var _level_complete_clip = preload("res://Sounds/complete.ogg") as AudioStream

func _ready():
	Global.attach_item.connect(check_all_itens)
	get_all_itens()
	
	audio_stream.volume_db = 0
	audio_stream.bus = "Music"
	pass

func get_all_itens() -> void:
	for item in get_tree().get_nodes_in_group('item'):
		if item is DropItem:
			_list_slots.append(item)
	pass

func check_all_itens() -> void:
	var all_on_position := true
	for item in _list_slots:
		if not item.is_on_slot():
			all_on_position = false
			break
	
	if all_on_position:
		Global.level_complete.emit()
		audio_stream.stream = _level_complete_clip
		audio_stream.play()
	pass
