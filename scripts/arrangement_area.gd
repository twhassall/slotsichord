extends Control



@onready var lines_container = $Lines
@onready var bpm_label = $BPMSlider/BPMLabel
@onready var bpm_slider = $BPMSlider
var slots = []

signal perform_pressed

func _ready():
	for line_index in range(4):
		#create a 'line' box
		var line = HBoxContainer.new()
		#change the spacing of the newly made box so lines merge together properly
		
		#todo borders
		line.add_theme_constant_override("separation", 0)
		
		#add this as a child of our container
		lines_container.add_child(line)
		bpm_label.text = str(MusicLibrary.bpm)

		
		var line_slots = []
		#maybe we can change this if we want more lines
		for number in range(4):
			# create  a bar slot
			var slot_scene = load("res://scenes/subScenes/BarSlot.tscn")
			var slot = slot_scene.instantiate()
			#add this barslot to the newly created line
			line.add_child(slot)
			#add to the end list
			line_slots.append(slot)
		
		#add a ref to all the slots so we can play through them all
		slots.append(line_slots)
		
		bpm_slider.value = MusicLibrary.bpm

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
	print("playing all bars")
	play_all_bars()

func _on_h_slider_value_changed(value: float):
	MusicLibrary.bpm = value
	bpm_label.text = str(value)

func _on_perfom_pressed():
	emit_signal("perform_pressed")
	
func set_buttons_disabled(is_disabled):
	print("self is: ", self)
	print("children: ", get_children())
	$Preview.disabled = is_disabled
	$Reset.disabled = is_disabled
	$Perform.disabled = is_disabled


func _on_reset_pressed():
	clear_all_bars()
