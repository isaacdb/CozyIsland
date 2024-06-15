extends Resource
class_name  PlaceItemData

const path_item = "res://NewComponents/ComposeItem/"

@export var item_name : String
@export var global_position : Vector2
@export var rotation_degrees : float
@export var scale : Vector2

func create(parent):
	var item = load(path_item + item_name + ".tscn") as PackedScene
	var new_item = item.instantiate() as PlaceItem
	parent.add_child(new_item)
	new_item.global_position = global_position
	new_item.rotation_degrees = rotation_degrees
	new_item.scale = scale
	pass
