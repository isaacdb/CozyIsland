extends ColorRect
class_name FadePanel

func _ready():
	z_index = 100
	Global.switch_level.connect(fade_out)
	
	visible = true
	color = Color("ffd861")
	
	fade_in()
	pass
	
func fade_in():
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_property(self, "visible", false, 0)
	tween.play()
	
func fade_out():
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	tween.play()
