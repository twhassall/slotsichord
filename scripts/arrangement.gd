extends Control


const BarChunk = preload("res://scenes/subScenes/barChunk.tscn")

#not sure how this works but apparently if you get errors then just change the nested node to access by unique name and use % alot
@onready var barArranger = %barArranger

var is_playing = false

func _ready():

	for bar in MusicLibrary.generated_bars:
		var chunk = BarChunk.instantiate()
		chunk.bar = bar 
		barArranger.add_child(chunk)

func _on_play_button_pressed() -> void:
	if is_playing:
		return 
	is_playing = true
	#create an array out of the children
	var ordered_bars = []
	for chunk in barArranger.get_children():
		ordered_bars.append(chunk.bar)
		#play all the bars
	await MusicLibrary.play_bars(ordered_bars)
	is_playing = false
