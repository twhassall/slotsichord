extends PanelContainer

#slots accet the drop
func _can_drop_data(at_position, data):
	return true
	#copy the bar data
func _drop_data(at_position, data):
	
	
	var bar_data = data["bar_data"]
	var came_from_bar = data["source_bar"]
	var parent_type = came_from_bar.get_parent()
	
	print("drop data: ",data)
	print("bar data: ", bar_data)
	print("came from bar: ", came_from_bar)

	# clear any bar already in this slot
	_clear_existing_bar()

	#if we are dragging from a slot then we are moving, so remove it from that vbar
	if parent_type.has_method("_drop_data"):
		came_from_bar.queue_free()
		
	var barDisplay = load("res://scenes/subScenes/BarArea.tscn")
	var thisBar = barDisplay.instantiate()
	add_child(thisBar)
	#otherwise we cant drop things on top becuase the bar blocks it
	thisBar.mouse_filter = Control.MOUSE_FILTER_PASS
	thisBar.set_bar(bar_data)
	thisBar.set_textures(MusicLibrary.bar_to_sprites(bar_data))

#cant find a way to check if the child is specifically a BarDisplay
#so just checking for a method we know barDisplay has
func get_bar_data():
	for child in get_children():
		if child.has_method("set_bar"):
			return child.bar_data
	return []
	
	
	#when we drop a bar, also clear the slot
func _clear_existing_bar():
	for slot in get_children():
		if slot.has_method("set_bar"):
			slot.queue_free()
