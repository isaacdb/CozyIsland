extends Control

@onready var _slider_music = $VBoxContainer/PanelContainer/VBoxContainer/SliderMusic as HSlider
@onready var _slider_sound = $VBoxContainer/PanelContainer2/VBoxContainer/SliderSound as HSlider
@onready var _settings_button = $Settings as Button
@onready var _container_settings = $VBoxContainer as VBoxContainer

const PATH := "user://audio_settings.ini"

var config_file: ConfigFile
var _settings_open : bool = false

func _ready():
	_setup_slider();
	_load();
	
	_settings_button.pressed.connect(click_settings)
	pass
	
func click_settings():
	_settings_open = !_settings_open
	var new_position : float
	if _settings_open:
		new_position = -50
	else:
		new_position = 300
	
	var tween = create_tween()
	tween.tween_property(_container_settings, "position:x", new_position, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	pass

func _setup_slider() -> void:
	_slider_music.max_value = 1.0
	_slider_music.step = 0.01
	_slider_music.value = 1.0
	_slider_music.value_changed.connect(Callable(_on_value_changed).bind("Music"))
	
	_slider_sound.max_value = 1.0
	_slider_sound.step = 0.01
	_slider_sound.value = 1.0
	_slider_sound.value_changed.connect(Callable(_on_value_changed).bind("Sound"))
	pass

func _on_value_changed(value: float, bus_name: String) -> void:
	config_file.load(PATH)
	config_file.set_value("audio", bus_name, value)
	config_file.save(PATH)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	pass

func _load():
	config_file = ConfigFile.new()
	if config_file.load(PATH) != OK:
		return;
	
	var music_value = config_file.get_value("audio", "Music", 1.0)
	if music_value is float and music_value >= 0.0 and music_value <= 1.0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_value))
		_slider_music.value = music_value
		
	var sound_value = config_file.get_value("audio", "Sound", 1.0)
	if sound_value is float and sound_value >= 0.0 and sound_value <= 1.0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(sound_value))
		_slider_sound.value = sound_value
	pass
	
	
