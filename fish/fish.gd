extends Resource
class_name Fish

@export var icon_texture: Texture2D
@export var pickup_texture: Texture2D
@export_file("*.tscn") var throw_scene_file
func instance():
	return load(throw_scene_file).instantiate()
