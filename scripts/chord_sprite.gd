extends TextureRect
@export var chord_name = "C"

func _ready():
	texture = MusicLibrary.chord_sprites[chord_name]
