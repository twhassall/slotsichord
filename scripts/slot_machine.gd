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
	
	player = AudioStreamPlayer.new()
	add_child(player)
	
	spinSound = load("res://assets/sounds/slotMachineSpin.wav")
	
	#test code - REMOVE THIS
	for i in range(5):
		
		render_bar(MusicLibrary.generate_bar())
	
func random_sprite_key():
	return MusicLibrary.beat_sprites.keys().pick_random()
	
func spin_reel(reel, final_key):
	player.stream = spinSound
	player.play()
	for i in range(20):
		reel.texture = MusicLibrary.beat_sprites[random_sprite_key()]
		await get_tree().create_timer(0.05).timeout
	reel.texture = MusicLibrary.beat_sprites[final_key]
	player.stop()
	
	
func spin_all_reels(bar):
	var key1 = MusicLibrary.beat_to_key(bar[0])
	var key2 = MusicLibrary.beat_to_key(bar[1])
	var key3 = MusicLibrary.beat_to_key(bar[2])
	var key4 = MusicLibrary.beat_to_key(bar[3])

	await spin_reel(reel1, key1)
	await MusicLibrary.play_beat(bar[0])
	await spin_reel(reel2, key2)
	await MusicLibrary.play_beat(bar[1])
	await spin_reel(reel3, key3)
	await MusicLibrary.play_beat(bar[2])
	await spin_reel(reel4, key4)
	await MusicLibrary.play_beat(bar[3])
	render_bar(current_bar)

func _on_spin_pressed():
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
	
