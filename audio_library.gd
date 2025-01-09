@icon("icon.svg")
class_name AudioLibrary extends Resource

@export var library: Dictionary = {}

func add_collection(collection: String, sounds: Array[AudioStream]):
	if collection.is_empty(): return
	library.merge({ collection: sounds })

func rename_collection(collection: String, new_name: String) -> bool:
	if library.has(collection):
		library[new_name] = library[collection]
		remove_collection(collection)
		return true
	return false

func remove_collection(collection: String) -> bool:
	if library.has(collection):
		library.erase(collection)
		return true
	return false

func add_sound(collection: String, sound: AudioStream) -> bool:
	if library.get(collection,false):
		library[collection].push_back(sound)
		return true
	return false

func get_sounds(collection: String) -> Array:
	return library.get(collection, [])

func has_collection(collection: String) -> bool:
	return library.has(collection)
	
func new_collection(collection: String) -> String:
	var new_number = library.keys().filter(func(key: String):
		return key.begins_with(collection)
	).size()
	var new_name = collection + "_%s" % [ new_number ]
	library[new_name] = []
	return new_name
