extends Node2D
class_name DropChance

@export var item_amount := 1;
@export_range(0, 100) var drop_chance : int = 100;

@onready var xp =  null #preload()

var rand := RandomNumberGenerator.new()

func _ready() -> void:
	rand.randomize();
	pass

func Execute() -> void:
	var rand_chance = rand.randi_range(0, 100)
	var must_drop = rand_chance >= 100 - drop_chance;
	
	if not must_drop:
		return
	
	for item in item_amount:
		var new_item = xp.instantiate()
		get_tree().get_root().get_child(0).call_deferred("add_child", new_item)
		new_item.global_position = self.global_position	
	pass
