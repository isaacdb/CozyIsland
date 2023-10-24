extends HBoxContainer


@export var prop_name : GeneralSettingsManager.PropName = GeneralSettingsManager.PropName.CAMERA_SHAKE
@export var prop_type : GeneralSettingsManager.PropType = GeneralSettingsManager.PropType.TOGGLE
@export var label_name : String = "Default"

@onready var spacer_toggle_button = %SpacerToggleButton as Control
@onready var toggle_button = %ToggleButton as CheckButton
@onready var slider = %Slider as HSlider
@onready var label = %Label as Label

const PATH := "user://general_settings.ini"

var config_file: ConfigFile

func _ready() -> void:
	toggle_button.toggled.connect(_on_toggle_button_changed);
	slider.value_changed.connect(_on_slider_value_changed);
	
	_setup_visibility_by_type();
	_load();
	pass

func _setup_visibility_by_type() -> void:
	label.text = label_name;
	spacer_toggle_button.visible = prop_type == GeneralSettingsManager.PropType.TOGGLE;
	toggle_button.visible = prop_type == GeneralSettingsManager.PropType.TOGGLE;
	slider.visible = prop_type == GeneralSettingsManager.PropType.SLIDER;
	pass
	
func _on_toggle_button_changed(pressed: bool) -> void:
	config_file.load(PATH)
	config_file.set_value("general", str(prop_name), pressed)
	GeneralSettingsManager.set_prop_setting_value(prop_name, pressed);
	config_file.save(PATH)
	pass
	
func _on_slider_value_changed(value: float) -> void:
	config_file.load(PATH)
	config_file.set_value("general", str(prop_name), value)
	GeneralSettingsManager.set_prop_setting_value(prop_name, value);
	config_file.save(PATH)
	pass

func _load():
	config_file = ConfigFile.new()
	if config_file.load(PATH) != OK:
		return;

	var prop_value = config_file.get_value("general", str(prop_name), 1)
	GeneralSettingsManager.set_prop_setting_value(prop_name, prop_value);
	
	if prop_type == GeneralSettingsManager.PropType.SLIDER:
		slider.value = prop_value;
	elif prop_type == GeneralSettingsManager.PropType.TOGGLE:
		toggle_button.button_pressed = prop_value;
	pass
