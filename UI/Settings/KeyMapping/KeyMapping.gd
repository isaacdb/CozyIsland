extends Control
class_name KeyMapping

@onready var input_button_scene = preload("res://UI/Settings/KeyMapping/InputButtonMap/input_button_map.tscn");
@onready var input_button_list = %InputButtonList as VBoxContainer
@onready var reset_button = %ResetButton as Button
@onready var button_back = %ButtonBack as Button

var is_remmaping := false
var action_to_remap : String
var remmaping_button : InputButtonMap = null

## C:\Users\isaac\AppData\Roaming\Godot\app_userdata\[Projeto]
const PATH := "user://key_mapping.ini"
const input_actions = {
	"click": "Click",
	"scroll_up": "Rotate up",
	"scroll_down": "Rotate down",
}

var config_file: ConfigFile

func _ready() -> void:
	config_file = ConfigFile.new();
	
	_load_config();
	_create_action_list();
	
	reset_button.button_down.connect(_reset_mapping);
	button_back.pressed.connect(_on_button_back_pressed);
	pass
	
func _on_button_back_pressed():
	self.visible = false
	pass
	
func _reset_mapping() -> void:
	InputMap.load_from_project_settings();
	_create_action_list();
	_save_config();
	pass

func _create_action_list() -> void:
	for item in input_button_list.get_children():
		item.queue_free();
	
	for action in input_actions:
		var button = input_button_scene.instantiate() as InputButtonMap;
		input_button_list.add_child(button);
		
		button.set_label_action(input_actions[action]);
		
		var events = InputMap.action_get_events(action);
		if events.size() > 0:
			button.set_label_input(events[0].as_text());
		else:
			button.set_label_input("");
		
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
	pass
		
func _on_input_button_pressed(button: InputButtonMap, action: String) -> void:
	if !is_remmaping:
		is_remmaping = true;
		action_to_remap = action;
		remmaping_button = button;
		button.set_label_input("Press key to bind...");
	pass

func _input(event: InputEvent) -> void:
	if is_remmaping:
		if event is InputEventKey || (event is InputEventMouseButton && event.pressed):
			
			# Ignore double click event
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap);
			InputMap.action_add_event(action_to_remap, event)
			_maintain_unique_key_mapping(event);
			remmaping_button.set_label_input(event.as_text())
			
			is_remmaping = false
			action_to_remap = ""
			remmaping_button = null
			
			_save_config();
			accept_event(); # Interrupt the action to propagate. Avoid issue with others script that listen inputs.
	pass
	
func _maintain_unique_key_mapping(event: InputEvent):
	for button in input_button_list.get_children() as Array[InputButtonMap]:
		if button.is_same_input(event.as_text()):
			button.set_label_input("");
			InputMap.action_erase_events(input_actions.find_key(button.label_action.text));
	pass

func _load_config():
	if config_file.load(PATH) != OK:
		return;
		
	var keybinds = config_file.get_value("keybinds", "keybinds", {})
	assert(keybinds is Dictionary and keybinds.has_all(input_actions.keys()), "Keybinds saved conflict." );
	
	for keybind in input_actions:
		InputMap.action_erase_events(keybind)
		for event in keybinds[keybind]:
			InputMap.action_add_event(keybind, event)
	pass

func _save_config():
	var dict := {}
	for action in input_actions:
		dict[action] = InputMap.action_get_events(action)
	config_file.set_value("keybinds", "keybinds", dict)
	var status = config_file.save(PATH)
	pass
