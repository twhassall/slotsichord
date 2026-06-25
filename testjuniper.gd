extends Node2D

func _ready():
	randomize()
	
func _on_make_her_move_pressed():
	$Juniper/JuniperAnimation.play("conduct")
	
	#Conduct and play - then cheer etc
	
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

##PROBLEM WITH JUNIPER SPRITE, a tiny pixel appears in the playback,
##but the sprite is definitely fine and there's nothing on the animation player

##think juniper issue is problem with art. Add a pixel between each sprite on the spritesheet
