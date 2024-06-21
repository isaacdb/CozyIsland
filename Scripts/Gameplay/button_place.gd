extends TextureRect

@export var item : PackedScene
@export var item_texture : Texture
@export var item_name : String

@onready var button = $"Button" as Button

func _ready():
	texture = item_texture
	Global.load_complete.connect(check_available)
	pass
	
func check_available() -> void:
	var avaiable = Global.list_itens_avaiable.any(func(i): return i == item_name)
	if avaiable:
		button.pressed.connect(on_pressed)
	else:
		modulate = Color.BLACK
	pass

func on_pressed():
	if Global.is_dragging: return
	
	var new_item = item.instantiate()
	var parent = get_tree().get_first_node_in_group('Items') as Node2D
	parent.add_child(new_item)
	new_item.new_instance()
	pass
