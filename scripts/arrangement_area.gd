extends Control



@onready var lines_container = $Lines
@onready var bpm_label = $BPMSlider/BPMLabel
@onready var bpm_slider = $BPMSlider
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
	for line in slots:
		for bit in line:
			var bar = bit.get_bar_data()
			var chord = bit.current_chord
			#we can change this - currently just skips empty bars
			if bar.is_empty() and chord == "":
				continue
				
			if chord != "":
				MusicLibrary.play_chord(chord)
			
			#time based on bpm just pause if no bar
			#adjust the chord sound itself if chord sound isnt long enough
			if bar.is_empty():
				await get_tree().create_timer(MusicLibrary.beat_duration() * 4).timeout
			else:	
				await MusicLibrary.play_bar(bar)

func clear_all_bars():
	for line in slots:
		for bit in line:
			bit._clear_existing_bar()
			bit.clear_existing_chord()
			
func _on_play_pressed():
	$PreviewButton/PreviewAnim.play("press")
	print("playing all bars")
	play_all_bars()

func _on_perfom_pressed():
	emit_signal("perform_pressed")
	$PerformButton/PerformAnim.play("press")
	
func set_buttons_disabled(is_disabled):
	print("self is: ", self)
	print("children: ", get_children())
	$PreviewButton/Preview.disabled = is_disabled
	$ResetButton/Reset.disabled = is_disabled
	$PerformButton/Perform.disabled = is_disabled


func _on_reset_pressed():
	$ResetButton/ResetAnim.play("press")
	clear_all_bars()


func _on_low_speed_pressed():
	set_bpm(80)


func _on_medium_speed_pressed():
	set_bpm(120)


func _on_high_speed_pressed():
	set_bpm(160)

func set_bpm(speed):
	MusicLibrary.bpm = speed
