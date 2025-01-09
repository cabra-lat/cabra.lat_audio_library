@icon("icon.svg")
extends Resource
class_name AudioLibrary

@export var library: Dictionary = {}  # A map between materials and sound arrays.

func add_collection(collection: String, sounds: Array[AudioStream]):
	if collection.is_empty(): return
	library.merge({ collection: sounds })

func remove_collection(collection: String):
	if library.has(collection):
		library.erase(collection)

func add_sound(collection: String, sound: AudioStream):
	if library.get(collection,false):
		library[collection].push_back(sound)

func get_sounds(collection: String) -> Array:
	return library.get(collection, [])
