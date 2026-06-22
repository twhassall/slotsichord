extends PanelContainer

@onready var renderer = $BarRenderer
var bar = []

func _ready():
	renderer.set_bar(bar)

func _get_drag_data(at_position):
	#get the 'data ' which is used in later methods
	#ngl i had to ai this shit to work out how to get the ghost of the notes to show but it looks cool af now hope its worth it
	#godot ui stuff is so easy
	var ghost =duplicate()
	ghost.get_node("BarRenderer").set_bar(bar)
	set_drag_preview(ghost)
	return self

#return true if we can drop here
func _can_drop_data(at_position, data):
	return data != self

#drop it based on its position in the barr arrangers children nodes
func _drop_data(at_position, data):
	get_parent().move_child(data, get_index())
