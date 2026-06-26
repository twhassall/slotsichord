extends Node2D

@onready var letter = $Letter

func show_chord(chord_name):
	if chord_name == "":
		visible = false
	else:
		letter.texture = MusicLibrary.chord_sprites[chord_name]
		visible = true
