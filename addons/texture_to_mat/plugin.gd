@tool
extends EditorPlugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	add_tool_menu_item("Create Materials from Textures", _on_menu_item_pressed)

func _exit_tree() -> void:
	remove_tool_menu_item("Create Materials from Textures")

func _on_menu_item_pressed() -> void:
	var interface = get_editor_interface()
	var selected_paths = interface.get_selected_paths()
	
	if selected_paths.is_empty():
		print("Texture2Mat: No files selected.")
		return
	
	_generate_materials_from_paths(selected_paths)

func _generate_materials_from_paths(paths: PackedStringArray):
	var interface = get_editor_interface()
	var created_count = 0

	for path in paths:
		var ext = path.get_extension().to_lower()
		if ext in ["png", "jpg", "jpeg", "webp", "tga"]:
			_create_standard_mat(path)
			created_count += 1
	
	interface.get_resource_filesystem().scan()
	print("Texture2Mat: Successfully created %d materials." % created_count)

func _create_standard_mat(tex_path):
	var tex = load(tex_path)
	if tex:
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = tex
		var save_path = tex_path.get_basename() + ".tres"
		ResourceSaver.save(mat, save_path)
