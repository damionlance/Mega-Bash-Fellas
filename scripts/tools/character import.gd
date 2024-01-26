@tool
extends EditorScenePostImport


# Called when the node enters the scene tree for the first time.
func _post_import(scene):
	
	iterate(scene)

func iterate(node):
	if node.name == "AnimationPlayer":
		set_save_custom_tracks(node)
	for child in node.get_children():
		iterate(child)

func set_save_custom_tracks(node):
	var animation_names = node.get_animation_list()
