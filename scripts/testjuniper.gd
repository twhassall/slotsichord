extends Node2D

signal encore_pressed

func _ready():
	randomize()
	$EncoreButton.frame=0
	$EncoreButton.visible = false
	$PlayAgainButton.frame=0
	$PlayAgainButton.visible = false
	
func start_conducting():	
	$Juniper/JuniperAnimation.play("conduct")

func stop_conducting():
	$Juniper/JuniperAnimation.pause()
	
func audience_reaction():
	var cheer_count = 0
	var clap_count = 0
	var cricket_count = 0

	for i in range(1, 8):
		var patron = get_node("Audience" + str(i))
		var roll = randf()
		##big cheer
		if roll < 0.4:
			patron.frame = 0
			var height = randf_range(5.0, 15.0)
			var duration = randf_range(0.25, 0.45)
			patron.cheer(height, duration)
			cheer_count +=1
		##polite applause
		elif roll < 0.75:
			patron.frame = 1
			var height = randf_range(1.0, 5.0)
			var duration = randf_range(0.4, 0.7)
			patron.cheer(height, duration)
			clap_count +=1
		##no reaction
		else:
			patron.frame = 1
			cricket_count +=1

	##plays sound based on majority reaction
	if cheer_count >= clap_count and cheer_count >= cricket_count:
		$cheerSound.play()
	elif clap_count >= cricket_count:
		$clapSound.play()
	else:
		$cricketSound.play()

##buttons to press after performance
func _on_encore_pressed():
	$EncoreButton/EncoreAnim.play("press")
	emit_signal("encore_pressed")
	
	for i in range(1, 8):
		var patron = get_node("Audience" + str(i))
		patron.stop_cheering(1.0)
	
	##fade out sounds
	var fade = create_tween()
	fade.set_ease(Tween.EASE_IN_OUT)
	fade.set_trans(Tween.TRANS_SINE)
	fade.tween_property($cheerSound, "volume_db", -80.0, 2.0)
	fade.parallel().tween_property($clapSound, "volume_db", -80.0, 2.0)
	fade.parallel().tween_property($cricketSound, "volume_db", -80.0, 2.0)
	
	await fade.finished
	
	$cheerSound.stop()
	$clapSound.stop()
	$cricketSound.stop()
	$cheerSound.volume_db = 0.0
	$clapSound.volume_db = 0.0
	$cricketSound.volume_db = 0.0

func _on_play_again_pressed():
	$PlayAgainButton/PlayAgainAnim.play("press")
	
func set_buttons_disabled(is_disabled):
	$EncoreButton/Encore.disabled = is_disabled
	$PlayAgainButton/PlayAgain.disabled = is_disabled
