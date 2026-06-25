extends TextureRect
#this gets adjusted in the editor
@export var chord_name = "C"

func _ready():
	texture = MusicLibrary.chord_sprites[chord_name]
	
func _get_drag_data(at_position):
	
	var ghosty = duplicate()
	set_drag_preview(ghosty)

	return {
		"type": "chord",
		"chord_name": chord_name,
	}
