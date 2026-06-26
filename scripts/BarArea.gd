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

@onready var staves = [
	$SpecificBar/Beat1,
	$SpecificBar/Beat2,
	$SpecificBar/Beat3,
	$SpecificBar/Beat4,
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
	MusicLibrary.play_pickup()

	#give data - now as dict so we can check where it came from
	#that way we can have different behaviour dragging from machine vs arrangement area
	#also neewd to say it is a bar not a chord because they have differnet drop rules
	return {
		"type" : "bar",
		"bar_data": bar_data,
		"source_bar": self,
	}
	
func show_stave(visible):
	for stave in staves:
		if visible:
			stave.texture = load("res://assets/sprites/stave.png")
		else:
			#this is stupid but i cant think of a better way without losing the spacing
			stave.texture = load("res://assets/sprites/invisibleStave.png")
