extends Node2D
var cheer_tween: Tween
var rest_pos: float

func _ready():
	rest_pos = position.y
	self.frame = 1

func cheer(height: float, duration: float):
	cheer_tween = create_tween()
	cheer_tween.set_loops()
	cheer_tween.set_ease(Tween.EASE_IN_OUT)
	cheer_tween.set_trans(Tween.TRANS_SINE)
	cheer_tween.tween_property(self, "position:y", rest_pos - height, duration)
	cheer_tween.tween_property(self, "position:y", rest_pos, duration)

func stop_cheering(duration: float):
	if cheer_tween:
		cheer_tween.kill()
	var settle = create_tween()
	settle.set_ease(Tween.EASE_IN_OUT)
	settle.set_trans(Tween.TRANS_SINE)
	settle.tween_property(self, "position:y", rest_pos, duration)
	await settle.finished
	self.frame = 1
