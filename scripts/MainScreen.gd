extends Control

@onready var player = $AudioStreamPlayer
@onready var slotMachine = %SlotMachine

func _ready():
	##connects this script to the perform button in arrangement_area.gd
	$ArrangementArea.perform_pressed.connect(pan_to_performance)
	
func pan_to_performance():
	##moves the camera smoothly
	
	$ArrangementArea.set_buttons_disabled(true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Camera2D, "position", Vector2(1360.0,324.0), 2.0)
	
	
	await tween.finished
	
	#magic timer
	#this is where we can play audience noises if we have them
	await get_tree().create_timer(0.5).timeout
	
	#just call directly
	$JuniperNode.start_conducting()
	await $ArrangementArea.play_all_bars()
	$JuniperNode.stop_conducting()
	#pause before reaction
	#feel free to adjust!
	await get_tree().create_timer(1).timeout
	$JuniperNode.audience_reaction()
