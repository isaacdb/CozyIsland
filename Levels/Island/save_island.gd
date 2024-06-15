extends Resource
class_name SaveIsland

const SAVE_PATH := "user://save"

@export var list_itens: Array[PlaceItemData]
@export var list_avaiable_itens: Array[String]
@export var current_level: String

func save_game():
	var save = ResourceSaver.save(self, get_save_path())
	
static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())

# This function allows us to save and load a text resource in debug builds and a
# binary resource in the released product.
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_PATH + extension

static func load_savegame() -> Resource:
	var save_path := get_save_path()
	if ResourceLoader.has_cached(save_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the save game.
		return ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_REUSE)

	# /!\ Workaround for bug https://github.com/godotengine/godot/issues/59686
	# Without that, sub-resources will not reload from the saved data.
	# We copy the SaveGame resource's data to a temporary file, load that file
	# as a resource, and make it take over the save game.

	# We first load the save game resource's content as a byte array and store it.
	var file = FileAccess.open(save_path, FileAccess.READ) as FileAccess

	var data := file.get_buffer(file.get_length())
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the save game to that temporary file path.
	var file_write = FileAccess.open(tmp_file_path, FileAccess.WRITE)

	file_write.store_buffer(data)
	file_write.close()

	# We load the temporary file as a resource.
	var save = ResourceLoader.load(tmp_file_path, "", ResourceLoader.CACHE_MODE_REUSE)
	# And make it take over the save path for the next time the player
	# saves.
	save.take_over_path(save_path)

	# We delete the temporary file.
	var directory := DirAccess.remove_absolute(tmp_file_path)
	return save
	
	
static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"
