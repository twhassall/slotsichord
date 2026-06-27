extends Node2D

@onready var letter = $Letter
@onready var box = $Box

func show_chord(chord_name):
	if chord_name == "":
		letter.visible = false
	else:
		letter.texture = MusicLibrary.chord_sprites[chord_name]
		letter.visible = true
