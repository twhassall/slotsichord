extends Control

@onready var player = $AudioStreamPlayer

const CROTCHET = 1.0
const QUAVER = 0.5
##we can change bpm to change tempo. give player this power
var bpm = 120.0
##turns real seconds into musical time
func beat_duration():
	return 60.0 / bpm

const NOTES = ["C", "D", "E", "G", "A", "C2"]

var sounds = {}
var current_bar = []

func _ready():
	randomize()
	sounds["C"] = load("res://assets/sounds/notes/C.wav")
	sounds["D"] = load("res://assets/sounds/notes/D.wav")
	sounds["E"] = load("res://assets/sounds/notes/E.wav")
	sounds["G"] = load("res://assets/sounds/notes/G.wav")
	sounds["A"] = load("res://assets/sounds/notes/A.wav")
	sounds["C2"] = load("res://assets/sounds/notes/C2.wav")
	update_counter()

func generate_beat():
	##range affect how often certain length of notes appear. We don't want too many rests.
	var roll = randi_range(1, 100)
	##Crotchet note
	if roll <= 40:
		return [[NOTES.pick_random(),CROTCHET]]
	##Crotchet rest
	elif roll <=50:
		return [["REST",CROTCHET]]
	##Quaver note + quaver rest
	elif roll <=70: 
		return [[NOTES.pick_random(),QUAVER],["REST",QUAVER]]
	##Quaver rest + quaver note
	elif roll <=90:
		return [["REST",QUAVER],[NOTES.pick_random(),QUAVER]]
	##Quaver note + quaver note
	else:
		return [[NOTES.pick_random(),QUAVER],[NOTES.pick_random(),QUAVER]]

func generate_bar():
	var bar = []
	for i in range(4):
		bar.append(generate_beat())
	return bar
	
func beat_to_key(beat):
	if beat.size() == 1:
		return "crot_" + note_to_sprite_name(beat[0][0])
	else:
		return "quav_" + note_to_sprite_name(beat[0][0]) + note_to_sprite_name(beat[1][0])
		
func note_to_sprite_name(note):
	match note:
		"C": return "c"
		"D": return "d"
		"E": return "e"
		"G": return "g"
		"A": return "a"
		"C2": return "c2"
		"REST": return "r"

func play_bar(bar):
	for beat in bar:
		for note in beat:
			var pitch = note[0]
			var duration = note[1]
		
			if pitch != "REST":
				player.stream = sounds[pitch]
				player.play()
		
			await get_tree().create_timer(duration * beat_duration()).timeout
		
func _on_button_pressed():
	#changed this method a bit tommy - i figured maybe we want the player to spin a few times and choose one they like, rather than immeditealy appending to the MusicLibrary list
	#so added a save button and option to play the current bar manually or re spin
	#but happy to switch back - maybe makes more sense that you opnly get 4 spins, then have to pick based on what you randomly got!
	current_bar = generate_bar()
	print (current_bar)
	await play_bar(current_bar)


func _on_move_to_arrangement_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/actualScreens/arrangement.tscn")


func _on_save_bar_button_pressed():
	if current_bar.is_empty():
		return  
	if MusicLibrary.generated_bars.size() >= 4:
		return  
	MusicLibrary.generated_bars.append(current_bar)
	current_bar = []  
	update_counter()

func update_counter():
	$VBoxContainer/numberOfSvedBars.text = "Saved: %d / 4" % MusicLibrary.generated_bars.size()
