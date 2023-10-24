extends HBoxContainer
class_name AudioSlider

## Check if the default audio bus definied on Audio Project Setting it's the right one;
## Configure each of the AudioStreamPlayer to use the correct bus;

@export var bus_name : String
@export var label_name : String

@onready var h_slider = %HSlider as HSlider
@onready var label = %Label as Label

const PATH := "user://audio_settings.ini"

var config_file: ConfigFile

func _ready():
	_setup_slider();
	_load();
	pass

func _setup_slider() -> void:
	label.text = label_name
	h_slider.max_value = 1.0
	h_slider.step = 0.01
	h_slider.value_changed.connect(_on_value_changed)
	pass

func _on_value_changed(value: float) -> void:
	config_file.load(PATH)
	config_file.set_value("audio", bus_name, value)
	config_file.save(PATH)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	pass

func _load():
	config_file = ConfigFile.new()
	if config_file.load(PATH) != OK:
		return;
	
	var master_value = config_file.get_value("audio", bus_name, 1.0)
	if master_value is float and master_value >= 0.0 and master_value <= 1.0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(master_value))
		h_slider.value = master_value
	pass
