extends Node

@onready var tip = $Tip as Label
@onready var tip_mobile = $TipMobile as Label

func _ready():
	Global.control_change.connect(on_control_change)
	on_control_change()
	pass
	
func on_control_change():
	tip.visible = not GeneralSettingsManager.mobile
	tip_mobile.visible = GeneralSettingsManager.mobile
	pass


