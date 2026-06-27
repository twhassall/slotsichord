extends Control

@onready var reel1 = $Reel1
@onready var reel2 = $Reel2
@onready var reel3 = $Reel3
@onready var reel4 = $Reel4

@onready var barOuputarea = $BarOutputArea

var current_bar = []
var spinSound
var player: AudioStreamPlayer
var spinNum
var chords_shown = false

signal coin_inserted

func _ready():
	##for random smoke animation
	randomize()
	smoke_loop()
	
	$Chords.modulate.a = 0.0
	
	spinNum = 0
	$SpinsLeft.frame = 0
	
	$SlotMachine/InsertCoinButton.frame = 0

	player = AudioStreamPlayer.new()
	add_child(player)
	
	spinSound = load("res://assets/sounds/slotMachine/slotMachineSpin.wav")
	reel1.texture = MusicLibrary.beat_sprites["crot_r"]
	reel2.texture = MusicLibrary.beat_sprites["crot_r"]
	reel3.texture = MusicLibrary.beat_sprites["crot_r"]
	reel4.texture = MusicLibrary.beat_sprites["crot_r"]
	


func random_sprite_key():
	return MusicLibrary.beat_sprites.keys().pick_random()
	
func start_spin_reel(reel, stop_time: float):
	var elapsed = 0.0
	var ease_in_duration = 0.4
	var brake_duration = 1.0
	
	while reel.get_meta("spinning") == true:
		reel.texture = MusicLibrary.beat_sprites[random_sprite_key()]
		
		var time_left = stop_time - elapsed
		
		var delay: float
		if elapsed < ease_in_duration:
			var t = elapsed / ease_in_duration
			delay = lerp(0.15, 0.03, t * t)
		elif time_left > brake_duration:
			delay = 0.03
		else:
			var t = 1.0 - clamp(time_left / brake_duration, 0.0, 1.0)
			delay = lerp(0.03, 0.15, t)
		
		elapsed += delay
		await get_tree().create_timer(delay).timeout
		
func _set_blur(reel, visible:bool):
	##blurs stop animating and vanish
	if reel == reel1:
		$Reel1/Blur1.visible = visible
		if visible: $Reel1/Blur1/BlurAnimation1.play("blur1")
		else: $Reel1/Blur1/BlurAnimation1.stop()
	elif reel == reel2:
		$Reel2/Blur2.visible = visible
		if visible: $Reel2/Blur2/BlurAnimation2.play("blur2")
		else: $Reel2/Blur2/BlurAnimation2.stop()
	elif reel == reel3:
		$Reel3/Blur3.visible = visible
		if visible: $Reel3/Blur3/BlurAnimation3.play("blur3")
		else: $Reel3/Blur3/BlurAnimation3.stop()
	elif reel == reel4:
		$Reel4/Blur4.visible = visible
		if visible: $Reel4/Blur4/BlurAnimation4.play("blur4")
		else: $Reel4/Blur4/BlurAnimation4.stop()
	

func stop_spin_reel(reel, final_key):
	_set_blur(reel, false)
	reel.set_meta("spinning", false)
	reel.texture = MusicLibrary.beat_sprites[final_key]
	if reel == reel4:
		await get_tree().create_timer(0.1).timeout
		$spinSound.stop()
	
func start_all_reels():
	##to get reels all spinning together
	reel1.set_meta("spinning", true)
	reel2.set_meta("spinning", true)
	reel3.set_meta("spinning", true)
	reel4.set_meta("spinning", true)

	
	start_spin_reel(reel1, 1.4)
	await get_tree().create_timer(0.08).timeout
	start_spin_reel(reel2, 1.4 + 0.4 - 0.08)
	await get_tree().create_timer(0.08).timeout
	start_spin_reel(reel3, 1.4 + 0.8 - 0.16)
	await get_tree().create_timer(0.08).timeout
	start_spin_reel(reel4, 1.4 + 1.2 - 0.24)

func spin_all_reels(bar):
	var key1 = MusicLibrary.beat_to_key(bar[0])
	var key2 = MusicLibrary.beat_to_key(bar[1])
	var key3 = MusicLibrary.beat_to_key(bar[2])
	var key4 = MusicLibrary.beat_to_key(bar[3])
	
	start_all_reels()
	
	_timed_blur(reel1, 0.4,  1.2)
	_timed_blur(reel2, 0.48, 1.8)
	_timed_blur(reel3, 0.56, 2.6)
	_timed_blur(reel4, 0.64, 3.8)

	await get_tree().create_timer(1.4).timeout
	stop_spin_reel(reel1, key1)
	await MusicLibrary.play_beat(bar[0])

	await get_tree().create_timer(0.4).timeout
	stop_spin_reel(reel2, key2)
	await MusicLibrary.play_beat(bar[1])

	await get_tree().create_timer(0.4).timeout
	stop_spin_reel(reel3, key3)
	await MusicLibrary.play_beat(bar[2])

	await get_tree().create_timer(0.4).timeout
	stop_spin_reel(reel4, key4)
	await MusicLibrary.play_beat(bar[3])
	
	render_bar(current_bar)

var is_spinning := false

func _on_spin_pressed():
	##prevents lever from being spammed
	if is_spinning:
		return
	is_spinning = true
	
	current_bar = MusicLibrary.generate_bar()
	MusicLibrary.current_bar = current_bar
	$SlotMachine/Crank/CrankAnimation.play("Pull")
	$crankSound.play()
	await get_tree().create_timer(0.3).timeout
	$SpinsLeft.frame -= 1
	$spinSound.play()
	await get_tree().create_timer(0.3).timeout
	await spin_all_reels(current_bar)
	if spinNum <= 8 and not chords_shown:
		chords_shown = true
		var fade_in = create_tween()
		fade_in.set_ease(Tween.EASE_IN_OUT)
		fade_in.set_trans(Tween.TRANS_SINE)
		fade_in.tween_property($Chords, "modulate:a", 1.0, 3.0)
	await get_tree().create_timer(0.5).timeout
	await MusicLibrary.play_bar(current_bar)
	print (current_bar)
	

	
	is_spinning = false
	
	spinNum -= 1
	if spinNum == 0:
		$Spin.disabled = true

func render_bar(bar):
	var sprites = MusicLibrary.bar_to_sprites(bar)

	var bar_scene = load("res://scenes/subScenes/BarArea.tscn")
	var bar_node = bar_scene.instantiate()
	barOuputarea.add_child(bar_node)
	bar_node.set_textures(sprites)
	bar_node.set_bar(bar)
	
	bar_node.modulate.a = 0.0
	var fade_in = bar_node.create_tween()
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.tween_property(bar_node, "modulate:a", 1.0, 1.5)
	
	
func smoke_loop():
	while true:
		await get_tree().create_timer(randf_range(2.0, 8.0)).timeout
		$SlotMachine/CiggySmoke/CiggyAnimation.play("smoke1")

func reset_slotmachine():
	clear_all_bars()
	$Spin.disabled = false
	$SlotMachine/InsertCoinButton/InsertCoin.disabled = false
	$SlotMachine/InsertCoinButton.frame = 0
	
func start_slotmachine():
	clear_all_bars()
	spinNum = 8 
	$SpinsLeft.frame = 8
	$Spin.disabled = false
	
func clear_all_bars():
	for bar in barOuputarea.get_children():
		bar.queue_free()

func _on_insert_coin_pressed():
	MusicLibrary.play_button()
	$SlotMachine/InsertCoinButton/InsertCoinAnimation.play("press")
	$Funnel/CoinDrop.play("drop")
	$SlotMachine/InsertCoinButton/InsertCoin.disabled = true
	$airDrop.play()
	await get_tree().create_timer(1).timeout
	$coinHit.play()
	await get_tree().create_timer(0.2).timeout
	start_slotmachine()
	emit_signal("coin_inserted")
	
func reset_chords():
	chords_shown = false
	$Chords.modulate.a = 0.0
	
func _timed_blur(reel, start_after: float, stop_after: float):
	await get_tree().create_timer(start_after).timeout
	_set_blur(reel, true)
	await get_tree().create_timer(stop_after - start_after).timeout
	_set_blur(reel, false)
	
