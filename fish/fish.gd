extends Resource
class_name Fish

export var texture: Texture
export(String,FILE) onready var throw_scene = load(throw_scene)
func instance():
	return throw_scene.instance()
