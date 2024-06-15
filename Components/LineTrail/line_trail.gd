extends Line2D
class_name LineTrail

@export var lenght := 50
@export var target : Node2D

var point := Vector2.ZERO

func _ready():
	clear_points();
	if !target:
		target = get_parent()

func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	
	point = target.global_position
	add_point(point)
	
	while get_point_count() > lenght:
		remove_point(0)
	
	pass
