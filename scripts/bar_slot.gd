extends PanelContainer

#slots accet the drop
func _can_drop_data(at_position, data):
	return true
	#copy the bar data
func _drop_data(at_position, data):
	var barDisplay = load("res://scenes/subScenes/BarArea.tscn")
	var thisBar = barDisplay.instantiate()
	add_child(thisBar)
	thisBar.set_bar(data)
	thisBar.set_textures(MusicLibrary.bar_to_sprites(data))

#cant find a way to check if the child is specifically a BarDisplay
#so just checking for a method we know barDisplay has
func get_bar_data():
	for child in get_children():
		if child.has_method("set_bar"):
			return child.bar_data
	return []
