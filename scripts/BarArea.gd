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
