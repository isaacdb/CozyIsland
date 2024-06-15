extends Node


const PATH := "user://island_itens.ini"

var _config_file: ConfigFile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_value_changed(value: float, bus_name: String) -> void:
	#_config_file.load(PATH)
	#_config_file.set_value("audio", bus_name, value)
	#_config_file.save(PATH)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	pass
	
func _load():
	pass
	#_config_file = ConfigFile.new()
	#if _config_file.load(PATH) != OK:
		#return;
	#
	#var music_value = _config_file.get_value("audio", "Music", 1.0)
	#if music_value is float and music_value >= 0.0 and music_value <= 1.0:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_value))
		#_slider_music.value = music_value	
