extends Node

var current_scene = null
var _current_scene_path : String

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	pass 

func SwitchScene(path: String):
	call_deferred("DefferedSwitchScene", path)
	pass

func DefferedSwitchScene(path: String):
	Global.is_dragging = false
	_current_scene_path = path
	if is_instance_valid(current_scene):
		current_scene.free()
	var newScene = load(path)
	current_scene = newScene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	pass

func reload_current_scene():
	if not _current_scene_path:
		_current_scene_path = "res://Levels/level_01.tscn"
	
	call_deferred("DefferedSwitchScene", _current_scene_path)
	pass
