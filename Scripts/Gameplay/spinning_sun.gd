extends TextureRect

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "rotation_degrees", 360, 5.5).from(0.0)
	pass
