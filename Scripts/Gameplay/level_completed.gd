extends CanvasLayer

@export var next_scene : String
@export var current_level : String

@onready var button_next = $Control/ButtonNext as Button
@onready var button_restart = $Control/ButtonRestart as Button
@onready var level = $Control/Level as Label
@onready var button_home = $Control/ButtonHome as Button

var _levels_path := "res://Levels/"

func _ready():
	Global.level_complete.connect(completed)
	button_next.visible = false
	button_next.pressed.connect(next_level)
	button_restart.pressed.connect(on_restart)
	button_home.pressed.connect(on_home_pressed)
	level.text = current_level + "/20"
	pass

func completed() -> void:
	button_next.visible = true
	
	Global.current_scene = _levels_path + next_scene + ".tscn"
	save_level_progress()
	
	var tween = get_tree().create_tween()
	tween.tween_property(button_next, "position:y", 100, 1.5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).from(-200)
	tween.tween_callback(float_button)
	pass
	
func float_button():
	var start_pos = button_next.position
	
	var tween = create_tween().set_loops()
	tween.tween_property(button_next, "position:y", start_pos.y + 10, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(button_next, "position:y", start_pos.y - 10, 1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pass
	
func next_level() -> void:
	Global.switch_level.emit()

	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene(_levels_path + next_scene + ".tscn"))
	pass
	
func save_level_progress():
	var _save : SaveIsland
	if SaveIsland.save_exists():
		_save = SaveIsland.load_savegame() as SaveIsland
		_save.current_level = Global.current_scene
		_save.save_game()
	pass
	
func on_restart() -> void:
	Global.switch_level.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.reload_current_scene())
	pass
	
func on_home_pressed() -> void:
	Global.switch_level.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2.1)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene("res://Levels/island.tscn"))
	pass	
