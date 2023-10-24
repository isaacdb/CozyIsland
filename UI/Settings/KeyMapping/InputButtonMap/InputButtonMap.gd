extends Button
class_name InputButtonMap

@onready var label_action = %LabelAction as Label
@onready var label_input = %LabelInput as Label

func set_label_action(action: String) -> void:
	label_action.text = action;
	
func set_label_input(input: String) -> void:
	label_input.text = input.trim_suffix(" (Physical)");
	
func is_same_input(otherInput: String) -> bool:
	return label_input.text == otherInput.trim_suffix(" (Physical)");



