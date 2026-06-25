extends Control

@onready var reel1 = $Reel1
@onready var reel2 = $Reel2
@onready var reel3 = $Reel3
@onready var reel4 = $Reel4

@onready var barOuputarea = $BarOutputArea

var current_bar = []
var spinSound
var player: AudioStreamPlayer

func _ready():
	##for random smoke animation
	randomize()
	smoke_loop()

	player = AudioStreamPlayer.new()
	add_child(player)
	
	spinSound = load("res://assets/sounds/slotMachineSpin.wav")
	
	#test code - REMOVE THIS
	for i in range(5):
		
		render_bar(MusicLibrary.generate_bar())

func random_sprite_key():
	return MusicLibrary.beat_sprites.keys().pick_random()
	
func start_spin_reel(reel):
	while reel.get_meta("spinning") == true:
		reel.texture = MusicLibrary.beat_sprites[random_sprite_key()]
		await get_tree().create_timer(0.05).timeout

func stop_spin_reel(reel, final_key):
	reel.set_meta("spinning", false)
	reel.texture = MusicLibrary.beat_sprites[final_key]
	if reel == reel4:
		await get_tree().create_timer(0.1).timeout
		player.stop()
	
func start_all_reels():
	reel1.set_meta("spinning", true)
	reel2.set_meta("spinning", true)
	reel3.set_meta("spinning", true)
	reel4.set_meta("spinning", true)

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

func _on_spin_pressed():
	player.stream = spinSound
	player.play()
	current_bar = MusicLibrary.generate_bar()
	MusicLibrary.current_bar = current_bar
	##visual
	$SlotMachine/Crank/CrankAnimation.play("Pull")
	await spin_all_reels(current_bar)
	##audio
	await get_tree().create_timer(0.5).timeout
	await MusicLibrary.play_bar(current_bar)
	print (current_bar)
	
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
