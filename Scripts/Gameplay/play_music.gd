extends Node

@onready var music : AudioStream = preload("res://Sounds/BeachVibes.ogg")

func _ready():
	GeneralMusic.change_music(music, -20)
	pass
