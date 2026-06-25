extends PanelContainer

var bar_data = []

func set_bar(bar):
	bar_data = bar

@onready var note_rects = [
	$SpecificBar/Beat1/Note,
	$SpecificBar/Beat2/Note,
	$SpecificBar/Beat3/Note,
	$SpecificBar/Beat4/Note,
]

func set_textures(sprites):
	for i in range(4):
		note_rects[i].texture = sprites[i]

func _get_drag_data(at_position):
	#da data
	var data = bar_data

	#da ghost
	var ghost = duplicate()
	set_drag_preview(ghost)

	#give data - now as dict so we can check where it came from
	#that way we can have different behaviour dragging from machine vs arrangement area
	return {
		"bar_data": bar_data,
		"source_bar": self,
	}
