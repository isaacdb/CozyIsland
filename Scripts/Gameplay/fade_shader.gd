extends ColorRect
class_name FadeShader

func _ready():
	z_index = 100
	Global.switch_level.connect(fade_out)
	visible = true
	
	fade_in()
	pass
	
func fade_in():
	visible = true
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/position", 1, 2).from(-1.5)
	tween.tween_property(self, "visible", false, 0)
	tween.play()
	
func fade_out():
	visible = true
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/position", -1.5, 2)
	tween.play()
