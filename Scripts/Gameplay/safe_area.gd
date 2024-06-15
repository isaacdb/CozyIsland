extends Area2D
class_name SafeArea

@onready var collision_shape = $CollisionShape2D as CollisionShape2D
@onready var collision_shape_2 = $CollisionShape2D2 as CollisionShape2D

func get_rand_position() -> Vector2:
	var col_shape : CollisionShape2D
	
	if randf() > 0.5:
		col_shape = collision_shape
	else:
		col_shape = collision_shape_2
		
	var shape = col_shape.shape as Shape2D
	var spawn_area = shape.get_rect().size
	var origin_x = col_shape.global_position.x - (spawn_area.x / 2)
	var origin_y = col_shape.global_position.y - (spawn_area.y / 2)
	
	var x = randf_range(origin_x, origin_x + (spawn_area.x))
	var y = randf_range(origin_y, origin_y + (spawn_area.y))
	
	return Vector2(x, y)
