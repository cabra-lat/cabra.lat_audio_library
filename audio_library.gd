@icon("icon.svg")
@tool
class_name AudioLibrary extends Resource

@export var library: Dictionary = {}

static func _get_unique_name(keys: Array, name: String, sep: String = '_') -> String:
	if not name:
		return AudioLibrary._get_unique_name(keys,"new_collection",sep)
	
	# Check if the name is already unique
	if keys.find(name) == -1:
		return name
	
	var num_str = ""
	for char in name.reverse():
		if char.is_valid_int(): num_str = char + num_str
	var number = int(num_str) + 1
	var base_name = name.replace(num_str,'')
	
	# Generate a unique name
	while true:
		var attempt = "%s%d" % [base_name, number + 1]
		if keys.find(attempt) == -1:
			return attempt
		number += 1
	return ""

func rename_collection(old_name: String, new_name: String) -> String:
	if library.has(old_name) and old_name != new_name:
		var unique_name = AudioLibrary._get_unique_name(library.keys(), new_name)
		library[unique_name] = library[old_name]
		library[old_name] = null
		return unique_name
	return old_name

func remove_collection(collection: String) -> bool:
	if library.has(collection):
		library.erase(collection)
		return true
	return false

func create_collection(new_name: String) -> String:
	var unique_name = AudioLibrary._get_unique_name(library.keys(), new_name)
	library[unique_name] = [] as Array[AudioStream]
	return unique_name

func add_sound(collection: String, sound: AudioStream) -> void:
	var updated = library.get(collection, [])
	library[collection] = updated.push_back(sound)
	
func get_sounds(collection: String) -> Array[AudioStream]:
	return library.get(collection, [] as Array[AudioStream])

func has_collection(collection: String) -> bool:
	return library.has(collection)
