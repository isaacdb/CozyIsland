extends Node2D

@onready var logo_godot = $CanvasLayer/LogoGodot as TextureRect
@onready var fade = $CanvasLayer/Fade as ColorRect
@onready var jam_text = $CanvasLayer/JamText as Control
@onready var autor_text = $CanvasLayer/AutorText as Control
@onready var relax_text = $CanvasLayer/RelaxText as Control
@onready var fade_shader = $CanvasLayer/FadeShader as  ColorRect
@onready var skip_label = $CanvasLayer/Skip as Label

var _switching := false
var _can_skip := false

func _ready():
	skip_label.visible = false
	_load_progress()
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 0, 4)
	
	tween.tween_property(logo_godot, "modulate:a", 1, 2)
	tween.tween_interval(2)
	tween.tween_property(logo_godot, "modulate:a", 0, 2)
	
	tween.tween_property(jam_text, "position:y", 300, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_interval(2)
	tween.tween_property(jam_text, "position:y", 700, 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(autor_text, "position:y", 300, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_interval(2)
	tween.tween_property(autor_text, "position:y", 700, 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	tween.tween_property(relax_text, "position:y", 300, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_interval(5)
	tween.tween_property(relax_text, "modulate:a", 0, 2)
	tween.tween_interval(0.5)
	tween.tween_callback(_switch_scene)
	pass

func _process(delta):
	if not _can_skip:
		return

	if Input.is_action_just_pressed("space") or Input.is_action_just_pressed("click"):
		_switch_scene()
	pass
		
func _load_progress():
	var _save : SaveIsland
	if SaveIsland.save_exists():
		_save = SaveIsland.load_savegame() as SaveIsland
		Global.list_itens_avaiable = _save.list_avaiable_itens
		Global.current_scene = _save.current_level
		_can_skip = true
		skip_label.visible = true
	else:
		_save = SaveIsland.new()
		_save.current_level = "res://Levels/level_01.tscn"
		_save.save_game()
		Global.list_itens_avaiable = []
		Global.current_scene = "res://Levels/level_01.tscn"
	pass
	
func _switch_scene():
	if _switching: return
	
	_switching = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade_shader.material, "shader_parameter/position", -1.5, 2)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): SceneSwitcher.SwitchScene(Global.current_scene))
