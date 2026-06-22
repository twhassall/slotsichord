extends PanelContainer

var bar = []

func _get_drag_data(at_position):
	#basically this gets the 'data ' which is used in later methods
	set_drag_preview(duplicate()) 
	return self

#return true if we can drop here
func _can_drop_data(at_position, data):
	return data != self

#drop it based on its position in the barr arrangers children nodes
func _drop_data(at_position, data):
	get_parent().move_child(data, get_index())
