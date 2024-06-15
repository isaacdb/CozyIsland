extends Node2D
class_name PlayerInputManager

# Define a quantidade máxima de imprecisão em graus
var _max_imprecision_degrees := 3;
var _rand := RandomNumberGenerator.new()

func _ready() -> void:
	_rand.randomize();
	pass

func get_axis_input() -> Vector2:
	var directionH = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	var directionV = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	
	return Vector2 (directionH, directionV).normalized();
	
func get_mouse_direction(position_ref: Vector2) -> Vector2:
	var direction = (get_global_mouse_position() - position_ref).normalized();
	
	if get_axis_input() != Vector2.ZERO:
		return add_imprecision(direction);
	else:
		return direction;
	pass
	
func add_imprecision(direction: Vector2) -> Vector2:
	var imprecision_angle_vector = _rand.randf_range(-_max_imprecision_degrees, _max_imprecision_degrees)

	var imprecision_angle_radians = deg_to_rad(imprecision_angle_vector)
	return direction.rotated(imprecision_angle_radians)
	
func press_fire() -> bool:
	return Input.is_action_pressed("fire");
	
func press_melee() -> bool:
	return Input.is_action_pressed("melee");
	
func press_dash() -> bool:
	return Input.is_action_just_pressed("dash");
