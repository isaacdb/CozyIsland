extends Node

func get_resouces_by_folder(path: String) -> Array[Resource]:
	var listOfResources : Array[Resource] = [];
	var dir = DirAccess.open(path);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next();
		while file_name != "":
			
			## Fix bug to load resoucers at Web builds
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			
			if dir.current_is_dir():
				listOfResources.append_array(get_resouces_by_folder(path + file_name + "/"));
			else:
				if file_name.contains(".tres"):
					listOfResources.insert(0, ResourceLoader.load(path + file_name));
			file_name = dir.get_next();
	else:
		push_error("ERRO AO BUSCAR RESOURCES");
		
	return listOfResources;
