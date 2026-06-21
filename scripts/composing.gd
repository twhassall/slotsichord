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

func _ready():
	randomize()
	sounds["C"] = load("res://assets/sounds/notes/C.wav")
	sounds["D"] = load("res://assets/sounds/notes/D.wav")
	sounds["E"] = load("res://assets/sounds/notes/E.wav")
	sounds["G"] = load("res://assets/sounds/notes/G.wav")
	sounds["A"] = load("res://assets/sounds/notes/A.wav")
	sounds["C2"] = load("res://assets/sounds/notes/C2.wav")

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
	var random_bar = generate_bar()
	MusicLibrary.generated_bars.append(random_bar)
	print (MusicLibrary.generated_bars.size())
	print (random_bar)
	await play_bar(random_bar)
