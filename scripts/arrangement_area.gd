extends Control



@onready var lines_container = $Lines
##@onready var bpm_label = $BPMSlider/BPMLabel
##@onready var bpm_slider = $BPMSlider
var slots = []

signal perform_pressed

func _ready():

	for line in lines_container.get_children():
		var line_slots = []
		for slot in line.get_children():
			line_slots.append(slot)
		slots.append(line_slots)

	$PreviewButton.frame=0
	$PreviewButton.visible = true
	$ResetButton.frame=0
	$ResetButton.visible = true
	$PerformButton.frame=0
	$PerformButton.visible = true

func play_all_bars():
	#make a list of all slots
	var all_slots = []
	for line in slots:
		for bit in line:
			all_slots.append(bit)

	# find the index of the last slot with any bar or chord
	var last_index =-1
	
	for index in range(all_slots.size()):
		
		var bit = all_slots[index]
		if not bit.get_bar_data().is_empty() or bit.current_chord != "":
			last_index = index

	#play p to the end (+1 as arrays start at 0)
	for i in range(last_index + 1):
		var bit = all_slots[i]
		var bar = bit.get_bar_data()
		var chord = bit.current_chord

		if chord != "":
			MusicLibrary.play_chord(chord)

		if bar.is_empty():
			await get_tree().create_timer(MusicLibrary.beat_duration() * 4).timeout
		else:
			await MusicLibrary.play_bar(bar)

func clear_all_bars():
	for line in slots:
		for bit in line:
			bit._clear_existing_bar()
			bit.clear_existing_chord()
			bit.set_rest_visible(true)
			
func _on_play_pressed():
	MusicLibrary.play_button()
	$PreviewButton/PreviewAnim.play("press")
	print("playing all bars")
	play_all_bars()

func _on_perfom_pressed():
	emit_signal("perform_pressed")
	MusicLibrary.play_button()
	$PerformButton/PerformAnim.play("press")
	
func set_buttons_disabled(is_disabled):
	print("self is: ", self)
	print("children: ", get_children())
	$PreviewButton/Preview.disabled = is_disabled
	$ResetButton/Reset.disabled = is_disabled
	$PerformButton/Perform.disabled = is_disabled


func _on_reset_pressed():
	MusicLibrary.play_button()
	$ResetButton/ResetAnim.play("press")
	clear_all_bars()


func _on_low_speed_pressed():
	MusicLibrary.play_button_two()
	set_bpm(80)
	$LowSpeed/LowAnim.play("press")

func _on_medium_speed_pressed():
	MusicLibrary.play_button_two()
	set_bpm(120)
	$MediumSpeed/MedAnim.play("press")

func _on_high_speed_pressed():
	MusicLibrary.play_button_two()
	set_bpm(160)
	$HighSpeed/HighAnim.play("press")

func set_bpm(speed):
	MusicLibrary.bpm = speed
