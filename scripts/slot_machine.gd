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

signal coin_inserted

func _ready():
	##for random smoke animation
	randomize()
	smoke_loop()
	
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
	
func start_spin_reel(reel):
	while reel.get_meta("spinning") == true:
		reel.texture = MusicLibrary.beat_sprites[random_sprite_key()]
		await get_tree().create_timer(0.05).timeout

func stop_spin_reel(reel, final_key):
	reel.set_meta("spinning", false)
	reel.texture = MusicLibrary.beat_sprites[final_key]
	##blurs stop animating and vanish
	if reel == reel1:
		$Reel1/Blur1.visible = false
		$Reel1/Blur1/BlurAnimation1.stop()
	elif reel == reel2:
		$Reel2/Blur2.visible = false
		$Reel2/Blur2/BlurAnimation2.stop()
	elif reel == reel3:
		$Reel3/Blur3.visible = false
		$Reel3/Blur3/BlurAnimation3.stop()
	elif reel == reel4:
		$Reel4/Blur4.visible = false
		$Reel4/Blur4/BlurAnimation4.stop()
		await get_tree().create_timer(0.1).timeout
		$spinSound.stop()
	
func start_all_reels():
	##to get reels all spinning together
	reel1.set_meta("spinning", true)
	reel2.set_meta("spinning", true)
	reel3.set_meta("spinning", true)
	reel4.set_meta("spinning", true)
	##blurs appear and animate
	$Reel1/Blur1.visible = true
	$Reel2/Blur2.visible = true
	$Reel3/Blur3.visible = true
	$Reel4/Blur4.visible = true
	$Reel1/Blur1/BlurAnimation1.play("blur1")
	$Reel2/Blur2/BlurAnimation2.play("blur2")
	$Reel3/Blur3/BlurAnimation3.play("blur3")
	$Reel4/Blur4/BlurAnimation4.play("blur4")
	
	start_spin_reel(reel1)
	start_spin_reel(reel2)
	start_spin_reel(reel3)
	start_spin_reel(reel4)

func spin_all_reels(bar):
	var key1 = MusicLibrary.beat_to_key(bar[0])
	var key2 = MusicLibrary.beat_to_key(bar[1])
	var key3 = MusicLibrary.beat_to_key(bar[2])
	var key4 = MusicLibrary.beat_to_key(bar[3])

	start_all_reels()

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
	await get_tree().create_timer(1.2).timeout
	start_slotmachine()
	emit_signal("coin_inserted")
	
