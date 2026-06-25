extends Control

@onready var player = $AudioStreamPlayer
@onready var slotMachine = %SlotMachine

func _ready():
	##connects this script to the perform button in arrangement_area.gd
	$ArrangementArea.perform_pressed.connect(pan_to_performance)
	
func pan_to_performance():
	##moves the camera smoothly
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Camera2D, "position", Vector2(1360.0,324.0), 2.0)
