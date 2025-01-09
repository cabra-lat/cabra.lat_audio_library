@tool
extends Control

@onready var default_icon = preload("res://addons/cabra.lat_audio_library/icon.svg")

@export var library: AudioLibrary

@onready var file: EditorFileDialog = $file
@onready var dialog: AcceptDialog = $dialog
@onready var stream_list: ItemList = $hsc/vsc/vbc_streams/sub_vb/stream_list
@onready var collections: Tree = $hsc/vsc/vbc_collections/sub_vb/collections
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var msg_missing_collections: Label = $hsc/vsc/vbc_collections/sub_vb/collections/missing_collections_label
@onready var msg_missing_streams: Label = $hsc/vsc/vbc_streams/sub_vb/stream_list/missing_streams_label
@onready var resource_previewer = EditorInterface.get_resource_previewer()

func _ready() -> void:
	collections.clear()
	stream_list.clear()

func load_resource(rsc: AudioLibrary) -> void:
	collections.clear()
	stream_list.clear()
	var root = collections.create_item() # root node
	for collection in rsc.library:
		var item = collections.create_item(root)
		item.set_text(0,collection)
	library = rsc

func load_stream(path: String) -> void:
	var file_name = path.get_file()
	var id = stream_list.add_item(file_name, default_icon)
	resource_previewer.queue_resource_preview(path, self, "_on_audio_preview_ready", id)
	
func load_streams(directory: String) -> void:
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				load_stream(dir.plus(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: %s" % directory)

# Search and filter materials in the Tree based on the search box text
func _on_search_box_text_changed(new_text: String) -> void:
	var root = collections.get_root()
	if root:
		_filter_tree_items(root, new_text)

# Recursive filtering for TreeItems
func _filter_tree_items(item: TreeItem, filter_text: String) -> void:
	while item:
		var visible = item.get_text(0).find(filter_text) != -1
		item.set_visible(visible)
		if item.has_children():
			_filter_tree_items(item.get_first_child(), filter_text)
		item = item.get_next()

func _on_load_pressed() -> void:
	var last_dir = ProjectSettings.get_setting("audio_library/last_directory", "res://")
	file.current_dir = last_dir
	file.show()

func _on_file_file_selected(path: String) -> void:
	load_stream(path)

func _on_file_dir_selected(dir: String) -> void:
	load_streams(dir)

func _on_file_files_selected(paths: PackedStringArray) -> void:
	for path in paths:
		load_stream(path)

func _on_stream_list_item_selected(index: int) -> void:
	var selected_collection = collections.get_selected()
	if not selected_collection: return
	var collection = selected_collection.get_text(0)
	audio_player.stream = library[collection][index]

func _on_audio_preview_ready(path: String, preview: Texture2D, thumbnail_preview: Texture2D, id: Variant) -> void:
	# Handle the preview
	if preview:
		stream_list.set_item_icon(id, preview)
	else:
		push_warning("Failed to generate audio preview for: %s" % path)

func _on_new_pressed() -> void:
	var root = collections.get_root()
	var selected = collections.get_selected()
	var new = collections.create_item(root)
	var collection_name := library.new_collection("new_collection")
	new.set_text(0, collection_name)

func _on_delete_pressed() -> void:
	var collection = collections.get_selected().get_text(0)
	dialog.dialog_text = "Delete collection %s?" % [ collection ]
	dialog.popup_centered()

func _on_dialog_confirmed() -> void:
	collections.get_selected().free()

func _on_collections_item_edited() -> void:
	var selected = collections.get_selected()

func _on_collections_cell_selected() -> void:
	var selected = collections.get_selected()
	for i in collections.item_edited.get_connections():
		print(i)
