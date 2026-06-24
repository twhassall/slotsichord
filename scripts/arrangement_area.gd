extends Control



@onready var lines_container = $Lines
@onready var bpm_label = $BPMSlider/BPMLabel
var slots = []

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

func play_all_bars():
	for line in slots:
		for bit in  line:
			var bar = bit.get_bar_data()
			#we can change this - currently just skips empty bars
			if bar.is_empty():
				continue
			await MusicLibrary.play_bar(bar)


func _on_play_pressed():
	play_all_bars()

func _on_h_slider_value_changed(value: float):
	MusicLibrary.bpm = value
	bpm_label.text = str(value)
