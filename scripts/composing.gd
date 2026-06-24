extends Control

@onready var player = $AudioStreamPlayer
@onready var slotMachine = %SlotMachine

func _on_move_to_arrangement_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/actualScreens/arrangement.tscn")

func _on_save_bar_button_pressed():
	if slotMachine.current_bar.is_empty():
		return  
	if MusicLibrary.generated_bars.size() >= 4:
		return  
	MusicLibrary.generated_bars.append(slotMachine.current_bar)
	slotMachine.current_bar = []  
	update_counter()

func update_counter():
	$VBoxContainer/numberOfSvedBars.text = "Saved: %d / 4" % MusicLibrary.generated_bars.size()
