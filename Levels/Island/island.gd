extends Node2D
class_name Island

@onready var back_button = $CanvasLayer/BackButton as Button
@onready var button_info = $CanvasLayer/ButtonInfo as Button
@onready var info = $CanvasLayer/Info as Label

var _save : SaveIsland
var _parent_itens : Node2D
var _info_on := false

func _ready():
	back_button.pressed.connect(on_back_press)
	button_info.pressed.connect(on_info_press)
	_parent_itens = get_tree().get_first_node_in_group('Items')
	load_island()
	pass
	
func on_info_press() -> void:
	_info_on = !_info_on
	var tween = get_tree().create_tween()
	if _info_on:
		tween.tween_property(info, "position:y", 90, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(info, "position:y", -200, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.play()
	pass
	

func load_island():
	if SaveIsland.save_exists():
		_save = SaveIsland.load_savegame() as SaveIsland
	else:
		_save = SaveIsland.new()
		_save.save_game()
		
	for i in _save.list_itens:
		i.create(_parent_itens)
		
	if Global.list_itens_avaiable.size() > _save.list_avaiable_itens.size():
		_save.list_avaiable_itens = Global.list_itens_avaiable
	else:
		Global.list_itens_avaiable = _save.list_avaiable_itens
	pass

func save_island():
	var list_data : Array[PlaceItemData] = []
	
	var itens = get_tree().get_nodes_in_group('Item') as Array[PlaceItem]
	for i in itens:
		list_data.append(i.generate_data())
		
	_save.list_itens = list_data
	_save.save_game()
	pass
	
func on_back_press():
	save_island()
	Global.switch_level.emit()
	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene(Global.current_scene))
	pass
