extends Control
class_name AudioSettings

@onready var button_back = %ButtonBack as Button

func _ready():
	button_back.pressed.connect(_on_button_back_pressed);
	pass
	
func _on_button_back_pressed():
	print_debug("Button back press")
	pass
