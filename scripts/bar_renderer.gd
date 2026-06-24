extends Control

var bar = []

#gap between lines on the stave
const LINE_GAP = 10  
const STEP = LINE_GAP / 2 #this is each step note up

const NOTESPLACES = {"C": -6, "D": -5, "E": -4, "G": -2, "A": -1, "C2": 1}

#these are the 'centres' of each sprite shape
const UP= Vector2(8, 30)
const DOWN = Vector2(9,10)
const C = Vector2(13, 28)
const REST = Vector2(7, 22)
const QUAVERREST = Vector2(12, 15)

var upSprite
var downSprite
var cSprite
var restSprite
var quaverRestSprite
var upQuaverSprite
var downQuaverSprite
var cQuaverSprite


const STAVE_COLOR = Color(0.0, 0.0, 0.0, 1.0)
func _ready():
	upSprite = load("res://assets/sprites/notes/leftNote.png")
	downSprite= load("res://assets/sprites/notes/rightNote.png")
	cSprite = load("res://assets/sprites/notes/cNote.png")
	upQuaverSprite = load("res://assets/sprites/notes/leftNoteQuaver.png")
	downQuaverSprite= load("res://assets/sprites/notes/rightNoteQuaver.png")
	cQuaverSprite = load("res://assets/sprites/notes/cNoteQuaver.png")
	restSprite = load("res://assets/sprites/notes/fullRest.png")
	quaverRestSprite = load("res://assets/sprites/notes/halfRest.png")
	
	#this is for sizing on the arrangment screen
	custom_minimum_size = Vector2(170, 110)
	if bar.is_empty():
		set_bar([[["C",0.5],["REST",0.5]], [["REST",0.5],["C",0.5]], [["A",0.5],["C2",0.5]], [["C2",1]]])

func set_bar(value):
	bar = value
	queue_redraw()

func _draw():
	
	#overall height
	var stave_height= 4 * LINE_GAP
	var stave_top = ( size.y - stave_height) /2
	
	var stave_middle = stave_top + (2 * LINE_GAP )

	for i in range(5):
		var y = stave_top + i * LINE_GAP
		draw_line(Vector2(0,y), Vector2(size.x ,y), STAVE_COLOR,1.5)
	draw_line(Vector2(0, stave_top), Vector2(0, stave_top + stave_height), STAVE_COLOR,1.5)
	draw_line(Vector2(size.x ,stave_top), Vector2(size.x , stave_top + stave_height), STAVE_COLOR,1.5)

	if bar.is_empty():
		return

#size of the overall conatiner divided by 4 = bar width
	var barWidth = size.x / 4
	var time = 0

	for beat in bar:
		for note in beat:
			var pitch = note[0]
			var length = note[1]

				#x coord is just the time increment plus multiplier if its a quaver or half rest then times the number of the bar
			var x = (time + length /2) * barWidth
			if pitch == "REST":
				_draw_rest(x,stave_middle,length)
			else:
				var y = stave_middle - NOTESPLACES[pitch] * STEP
				_draw_note_sprite(x,y, pitch,length)
			time += length

#draw the sprites
func _draw_note_sprite(x,y, pitch,length):
	var sprite
	var centre
	if pitch == "C":
		if length == 1.0:
			sprite =cSprite
		else:
			sprite = cQuaverSprite
		centre =C
	elif NOTESPLACES[pitch] > 0: 
		if length == 1.0:
			sprite =downSprite
		else:
			sprite = downQuaverSprite
		centre =DOWN
	else:                               
		if length == 1.0:
			sprite =upSprite
		else:
			sprite = upQuaverSprite
		centre =UP
	draw_texture(sprite, Vector2(x,y) - centre)

func _draw_rest(x, y_middle, duration):
	var sprite
	var centre
	
	if duration >= 1:
		sprite =restSprite
		centre =REST
	else:
		sprite =quaverRestSprite
		centre =QUAVERREST
	draw_texture(sprite, Vector2(x,y_middle) - centre)
