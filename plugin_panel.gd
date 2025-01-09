@tool
class_name AudioLibraryPanel extends Control

@onready var default_icon = preload("res://addons/cabra.lat_audio_library/icon.svg")

@export var library: AudioLibrary

@onready var file_dialog: EditorFileDialog = $file
@onready var confirm_dialog: AcceptDialog = $dialog
@onready var stream_list: ItemList = $hsc/vsc/vbc_streams/sub_vb/stream_list
@onready var collections: Tree = $hsc/vsc/vbc_collections/sub_vb/collections
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var msg_current_library: Label = $hsc/Label
@onready var msg_missing_collections: Label = $hsc/vsc/vbc_collections/sub_vb/collections/missing_collections_label
@onready var msg_missing_streams: Label = $hsc/vsc/vbc_streams/sub_vb/stream_list/missing_streams_label
@onready var resource_previewer = EditorInterface.get_resource_previewer()

func _ready() -> void:
	collections.clear()
	stream_list.clear()

func _get_current_collection() -> String:
	var selected = collections.get_selected()
	if not selected: return ''
	var current_collection = selected.get_text(0)
	return current_collection

func load_resource(rsc: AudioLibrary) -> void:
	collections.clear()
	stream_list.clear()
	if not rsc: return
	var root = collections.create_item() # root node
	for collection in rsc.library:
		var item = collections.create_item(root)
		item.set_text(0,collection)
	library = rsc
	if not rsc.library.is_empty():
		msg_missing_collections.hide()
	update_status_line()

func load_current_collection() -> void:
	stream_list.clear()
	var collection = _get_current_collection()
	if library.library.is_empty():
		msg_missing_streams.show()
		msg_missing_collections.show()
	
	var sounds = library.get_sounds(collection)

	if not sounds.is_empty():
		msg_missing_streams.hide()
		for sound in sounds:
			load_stream_preview(sound.resource_path)

func load_stream_preview(path) -> void:
	var file_name = path.get_file()
	var id = stream_list.add_item(file_name, default_icon)
	resource_previewer.queue_resource_preview(path, self, "_on_audio_preview_ready", id)

func update_status_line(resource: Resource = null) -> void:
	msg_current_library.text = '%s%s%s' % [
		"%s - "  % (library.resource_name if library.resource_name else "Unnamed"),
		"(%s)" % library.resource_path if library.resource_path else "",
		" - saved " if resource is AudioLibrary else ""
	]

func load_stream(collection: String, path: String) -> void:
	load_stream_preview(path)
	var sound = ResourceLoader.load(path)
	print(sound, path)
	if sound:
		library.add_sound(collection, sound)
		msg_missing_streams.hide()
		return
	push_warning("Failed to load sound %s" % [path])

#region Search Box Logic
# Search and filter materials in the Tree based on the search box text
func _on_search_box_text_changed(query: String) -> void:
	var root = collections.get_root()
	if root: _filter_tree_items(root, query)

# Recursive filtering for TreeItems
func _filter_tree_items(item: TreeItem, filter_text: String) -> void:
	while item:
		item.visible = filter_text in item.get_text(0) \
					or filter_text.is_empty() \
					or item == collections.get_root()
		var child = item.get_first_child()
		if child:
			_filter_tree_items(child, filter_text)
		item = item.get_next_in_tree()
#endregion

#region Loading Streams
func _on_load_pressed() -> void:
	var last_dir = ProjectSettings.get_setting("audio_library/last_directory", "res://")
	file_dialog.current_dir = last_dir
	file_dialog.show()

func _on_file_file_selected(path: String) -> void:
	var collection = _get_current_collection()
	load_stream(collection, path)
	ProjectSettings.set_setting("audio_library/last_directory", path.get_base_dir())

func _on_file_dir_selected(directory: String) -> void:
	var collection = _get_current_collection()
	if collection.is_empty():
		collection = _on_new_pressed().get_text(0)
	var dir = DirAccess.open(directory)
	if not dir:
		push_error("Failed to open directory: %s" % directory)
		return
	for file in dir.get_files():
		for filter in file_dialog.filters:
			if file.match(filter):
				load_stream(collection, directory + '/' + file)
	ProjectSettings.set_setting("audio_library/last_directory", directory)

func _on_file_files_selected(paths: PackedStringArray) -> void:
	if paths.is_empty(): return
	for path in paths:
		var collection = _get_current_collection()
		load_stream(collection, path)
#endregion

func _on_stream_list_item_selected(index: int) -> void:
	var collection = _get_current_collection()
	audio_player.stream = library[collection][index]

func _on_audio_preview_ready(path: String, preview: Texture2D, thumbnail_preview: Texture2D, id: Variant) -> void:
	# Handle the preview
	if preview:
		stream_list.set_item_icon(id, preview)
	else:
		push_warning("Failed to generate audio preview for: %s" % path)

func _on_new_pressed(new_name: String = "new_collection") -> TreeItem:
	var root = collections.get_root()
	var new = collections.create_item(root)
	var actual_name := library.create_collection(new_name)
	new.set_text(0, actual_name)
	new.select(0)
	msg_missing_collections.hide()
	return new

func _on_delete_pressed() -> void:
	var selected = collections.get_selected()
	if not selected: return
	var collection = selected.get_text(0)
	confirm_dialog.dialog_text = "Delete collection %s?" % [ collection ]
	confirm_dialog.popup()

func _on_dialog_confirmed() -> void:
	var selected = collections.get_selected()
	if not selected: return
	var collection = selected.get_text(0)
	library.remove_collection(collection)
	selected.free()
	load_current_collection()

#region Collections (List of Collections in AudioLibrary)
func _on_collections_cell_selected() -> void:
	load_current_collection()

func _on_collections_item_activated() -> void:
	var selected: TreeItem = collections.get_selected()
	var current_name = selected.get_text(0)
	selected.set_tooltip_text(0,current_name)
	selected.set_editable(0, true)

func _on_collections_item_edited() -> void:
	var selected = collections.get_selected()
	var old_name = selected.get_tooltip_text(0)
	var new_name = selected.get_text(0)
	if new_name.is_empty():
		selected.set_text(0,old_name)
		return
	var actual_name = library.rename_collection(old_name, new_name)
	selected.set_text(0,actual_name) # In case the name was invalid and other was generated
	selected.set_tooltip_text(0,actual_name)
	print("Renamed collection ", old_name, " to ", actual_name)
#endregion

#region Playback Controls
func _on_play_pressed() -> void:
	print_debug("Playing current selected stream %s..." % [audio_player.stream.resource_path])
	audio_player.play()
	
func _on_stop_pressed() -> void:
	print_debug("Stopping current selected stream %s..." % [audio_player.stream.resource_path])
	audio_player.stop()
#endregion
