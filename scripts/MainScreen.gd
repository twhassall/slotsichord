extends Control

@onready var player = $AudioStreamPlayer
@onready var slotMachine = %SlotMachine

func _ready():
	##connects this script to the perform button in arrangement_area.gd
	$ArrangementArea.perform_pressed.connect(pan_to_performance)
	$JuniperNode.encore_pressed.connect(encore)
	$JuniperNode.play_again_pressed.connect(on_play_again)
	##connects to insert coin in slot_machine.gd
	$SlotMachine.coin_inserted.connect(pan_to_game)
	
func pan_to_game():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Camera2D, "position", Vector2(750.0,324.0), 2.0)
	
func pan_to_performance():
	$ArrangementArea.set_buttons_disabled(true)
	$JuniperNode.set_buttons_disabled(true)
	$TuneUp.play()
	$Chatter.play()
	
	##moves the camera smoothly
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Camera2D, "position", Vector2(1360.0,324.0), 2.0)
	
	##fade buttons as camera pans
	tween.parallel().tween_property($ArrangementArea/PreviewButton, "modulate:a", 0.0, 2.0)
	tween.parallel().tween_property($ArrangementArea/PerformButton, "modulate:a", 0.0, 2.0)
	tween.parallel().tween_property($ArrangementArea/ResetButton, "modulate:a", 0.0, 2.0)
	
	await tween.finished
	
	$ArrangementArea/PreviewButton.visible = false
	$ArrangementArea/PerformButton.visible = false
	$ArrangementArea/ResetButton.visible = false
	
	#magic timer
	#this is where we can play audience noises if we have them
	await get_tree().create_timer(2.0).timeout
	##fade out sounds
	var fade = create_tween()
	fade.set_ease(Tween.EASE_IN_OUT)
	fade.set_trans(Tween.TRANS_SINE)
	fade.tween_property($TuneUp, "volume_db", -80.0, 1.0)
	fade.parallel().tween_property($Chatter, "volume_db", -80.0, 4.0)
	await get_tree().create_timer(0.5).timeout
	await performance()
	
func performance():
	#just call directly
	$JuniperNode.start_conducting()
	await $ArrangementArea.play_all_bars()
	$JuniperNode.stop_conducting()
	#pause before reaction
	#feel free to adjust!
	await get_tree().create_timer(1).timeout
	$JuniperNode.audience_reaction()
	await get_tree().create_timer(1).timeout
	
	##Activate performance buttons at end
	$JuniperNode.set_buttons_disabled(false)
	$JuniperNode/EncoreButton.modulate.a = 0.0
	$JuniperNode/PlayAgainButton.modulate.a = 0.0
	$JuniperNode/EncoreButton.visible = true
	$JuniperNode/PlayAgainButton.visible = true
	
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.tween_property($JuniperNode/EncoreButton, "modulate:a", 1.0, 1.0)
	fade_in.parallel().tween_property($JuniperNode/PlayAgainButton, "modulate:a", 1.0, 1.0)
	
func encore():
	$JuniperNode.set_buttons_disabled(true)
	var fade_out = create_tween()
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.tween_property($JuniperNode/EncoreButton, "modulate:a", 0.0, 0.5)
	fade_out.parallel().tween_property($JuniperNode/PlayAgainButton, "modulate:a", 0.0, 0.5)
	performance()
	
func on_play_again():
	$ArrangementArea.clear_all_bars()
	%SlotMachine.reset_slotmachine()
	pan_back_to_start()
	$TuneUp.volume_db = -15.0
	$Chatter.volume_db = -15.0
	
func pan_back_to_start():	
	
	#fade out and disable performance buttons
	$JuniperNode.set_buttons_disabled(true)
	var fade_out = create_tween()
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.tween_property($JuniperNode/EncoreButton, "modulate:a", 0.0, 0.5)
	fade_out.parallel().tween_property($JuniperNode/PlayAgainButton, "modulate:a", 0.0, 0.5)
	
	##makes chords transparent again
	$SlotMachine.reset_chords()
	
	##moves the camera smoothly
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	#obvs set this to wherever the actual start menu is
	tween.tween_property($Camera2D, "position", Vector2(124.0,324.0), 2.0)
	
	#enable arrangement buttons
	$ArrangementArea.set_buttons_disabled(false)
	
	#fade in arrangement buttons
	$ArrangementArea/PreviewButton.modulate.a = 0.0
	$ArrangementArea/PerformButton.modulate.a = 0.0
	$ArrangementArea/ResetButton.modulate.a = 0.0
	$ArrangementArea/PreviewButton.visible = true
	$ArrangementArea/PerformButton.visible = true
	$ArrangementArea/ResetButton.visible = true
	
	var fade_in = create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.tween_property($ArrangementArea/PreviewButton, "modulate:a", 1.0, 1.0)
	fade_in.parallel().tween_property($ArrangementArea/PerformButton, "modulate:a", 1.0, 1.0)
	fade_in.parallel().tween_property($ArrangementArea/ResetButton, "modulate:a", 1.0, 1.0)
	
