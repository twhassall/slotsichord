extends Node2D

func _on_make_her_move_pressed():
	$Juniper/JuniperAnimation.play("conduct")

##PROBLEM WITH JUNIPER SPRITE, a tiny pixel appears in the playback,
##but the sprite is definitely fine and there's nothing on the animation player
