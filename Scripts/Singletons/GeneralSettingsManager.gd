extends Node
## Singleton - GeneralSettingsManager

var cameraShake: bool = true
var dustParticles: bool = true


func set_prop_setting_value(prop: PropName, value) -> void:
	match prop:
		PropName.CAMERA_SHAKE:
			cameraShake = value
		PropName.DUST_PARTICLE:
			dustParticles = value
		_:
			assert(false, "Prop setting '" + str(prop) + "' is not mapped");
	pass

enum PropName {
	CAMERA_SHAKE,
	DUST_PARTICLE
}

enum PropType {
	TOGGLE,
	SLIDER
}
