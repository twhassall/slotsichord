extends Node2D
var cheer_tween: Tween

func cheer(height: float, duration: float):
	var start_pos = position.y
	cheer_tween = create_tween()
	cheer_tween.set_loops()
	cheer_tween.set_ease(Tween.EASE_IN_OUT)
	cheer_tween.set_trans(Tween.TRANS_SINE)
	cheer_tween.tween_property(self, "position:y", start_pos - height, duration)
	cheer_tween.tween_property(self, "position:y", start_pos, duration)
