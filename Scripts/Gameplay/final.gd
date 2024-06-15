extends Node

@onready var button = $CanvasLayer/Button as Button
@onready var button_home = $CanvasLayer/ButtonHome as Button

func _ready():
	button.pressed.connect(restart)
	button_home.pressed.connect(on_home_pressed)
	pass

func restart():
	Global.current_scene = "res://Levels/level_01.tscn"
	Global.switch_level.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene("res://Levels/level_01.tscn"))
	pass

func on_home_pressed() -> void:
	Global.switch_level.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene("res://Levels/island.tscn"))
	pass
