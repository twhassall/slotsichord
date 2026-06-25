extends Node2D

func _on_make_her_move_pressed():
	$Juniper/JuniperAnimation.play("conduct")

	for i in range(1, 8):
		var patron = get_node("Audience" + str(i))
		var height = randf_range(5.0, 15.0)
		var duration = randf_range(0.25, 0.45)
		patron.frame = 0
		patron.cheer(height, duration)

##PROBLEM WITH JUNIPER SPRITE, a tiny pixel appears in the playback,
##but the sprite is definitely fine and there's nothing on the animation player

##think juniper issue is problem with art. Add a pixel between each sprite on the spritesheet
