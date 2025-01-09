@tool
extends Control

@onready var file: EditorFileDialog = $file
@onready var stream_list: ItemList = $HSplitContainer/vbc_streams/sub_vb/stream_list
@onready var collections: Tree = $HSplitContainer/vbc_collections/sub_vb/collections
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var msg_missing_collections: Label = $HSplitContainer/vbc_collections/sub_vb/collections/missing_collections_label
@onready var msg_missing_streams: Label = $HSplitContainer/vbc_streams/sub_vb/stream_list/missing_streams_label

func load_streams(directory: String) -> void:
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				stream_list.add_item(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: %s" % directory)

# Search and filter materials in the Tree based on the search box text
func _on_search_box_text_changed(new_text: String) -> void:
	var root_item = $materials.get_root()
	if root_item:
		_filter_tree_items(root_item, new_text)

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

func _on_file_files_selected(paths: PackedStringArray) -> void:
	if paths.size() > 0:
		var selected_path = paths[0]
		ProjectSettings.set_setting("audio_library/last_directory", selected_path.get_base_dir())
		load_streams(selected_path)

func _on_stream_list_item_selected(index: int) -> void:
	var selected_file = stream_list.get_item_text(index)
	var last_dir = ProjectSettings.get_setting("audio_library/last_directory", "res://")
	var full_path = last_dir.plus_file(selected_file)

	# Queue resource preview
	var resource_previewer = EditorInterface.get_resource_previewer()
	if resource_previewer:
		resource_previewer.queue_resource_preview(full_path, self, "_on_audio_preview_ready", null)
	else:
		push_error("Failed to access EditorResourcePreview.")

func _on_audio_preview_ready(path: String, preview: Texture2D, thumbnail_preview: Texture2D, userdata: Variant) -> void:
	# Handle the preview
	if preview:
		pass
		#audio_preview.stream = preview
		#audio_preview.play()
	else:
		push_error("Failed to generate audio preview for: %s" % path)
