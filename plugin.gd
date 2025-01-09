@tool
extends EditorPlugin

var inspector_plugin: Control

func _enter_tree():
	inspector_plugin = preload("res://addons/cabra.lat_audio_library/plugin.tscn").instantiate()
	print("Audio Library Editor Plugin Enabled")

func _exit_tree():
	print("Audio Library Editor Plugin Disabled")
	if inspector_plugin:
		remove_control_from_bottom_panel(inspector_plugin)
		inspector_plugin.queue_free()
		inspector_plugin = null

# Called to check if this plugin handles the given resource
func _handles(object: Object) -> bool:
	return object is AudioLibrary  # Replace 'AudioLibrary' with your actual class name

# Called when a resource is selected in the inspector
func _edit(object: Object) -> void:
	if object is AudioLibrary:  # Replace 'AudioLibrary' with your actual class name
		print("Editing AudioLibrary resource")
		remove_control_from_bottom_panel(inspector_plugin)
		add_control_to_bottom_panel(inspector_plugin, "Audio Library")
		make_bottom_panel_item_visible(inspector_plugin)
	else:
		remove_control_from_bottom_panel(inspector_plugin)
		hide_bottom_panel()
