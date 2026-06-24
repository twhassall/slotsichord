extends PanelContainer

#slots accet the drop
func _can_drop_data(at_position, data):
	return true
	#copy the bar data
func _drop_data(at_position, data):
	var barDisplay = load("res://scenes/subScenes/BarDisplay.tscn")
	var thisBar = barDisplay.instantiate()
	add_child(thisBar)
	thisBar.set_bar(data)
	thisBar.set_textures(MusicLibrary.bar_to_sprites(data))
