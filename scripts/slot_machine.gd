extends Control

@onready var reel1 = $HBoxContainer/Reel1
@onready var reel2 = $HBoxContainer/Reel2
@onready var reel3 = $HBoxContainer/Reel3
@onready var reel4 = $HBoxContainer/Reel4

var beat_sprites = {}
var current_bar = []

func _ready():
	beat_sprites["crot_c"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_c.png")
	beat_sprites["crot_d"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_d.png")
	beat_sprites["crot_e"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_e.png")
	beat_sprites["crot_g"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_g.png")
	beat_sprites["crot_a"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_a.png")
	beat_sprites["crot_c2"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_c2.png")
	beat_sprites["crot_r"] = load("res://assets/sprites/SLOTMACHINEnotes/crot_r.png")
	
	beat_sprites["quav_cc"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_cc.png")
	beat_sprites["quav_cd"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_cd.png")
	beat_sprites["quav_ce"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ce.png")
	beat_sprites["quav_cg"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_cg.png")
	beat_sprites["quav_ca"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ca.png")
	beat_sprites["quav_cc2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_cc2.png")
	beat_sprites["quav_cr"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_cr.png")
	
	beat_sprites["quav_dc"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_dc.png")
	beat_sprites["quav_dd"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_dd.png")
	beat_sprites["quav_de"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_de.png")
	beat_sprites["quav_dg"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_dg.png")
	beat_sprites["quav_da"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_da.png")
	beat_sprites["quav_dc2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_dc2.png")
	beat_sprites["quav_dr"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_dr.png")
	
	beat_sprites["quav_ec"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ec.png")
	beat_sprites["quav_ed"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ed.png")
	beat_sprites["quav_ee"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ee.png")
	beat_sprites["quav_eg"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_eg.png")
	beat_sprites["quav_ea"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ea.png")
	beat_sprites["quav_ec2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ec2.png")
	beat_sprites["quav_er"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_er.png")
	
	beat_sprites["quav_gc"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_gc.png")
	beat_sprites["quav_gd"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_gd.png")
	beat_sprites["quav_ge"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ge.png")
	beat_sprites["quav_gg"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_gg.png")
	beat_sprites["quav_ga"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ga.png")
	beat_sprites["quav_gc2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_gc2.png")
	beat_sprites["quav_gr"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_gr.png")
	
	beat_sprites["quav_ac"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ac.png")
	beat_sprites["quav_ad"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ad.png")
	beat_sprites["quav_ae"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ae.png")
	beat_sprites["quav_ag"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ag.png")
	beat_sprites["quav_aa"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_aa.png")
	beat_sprites["quav_ac2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ac2.png")
	beat_sprites["quav_ar"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ar.png")
	
	beat_sprites["quav_c2c"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2c.png")
	beat_sprites["quav_c2d"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2d.png")
	beat_sprites["quav_c2e"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2e.png")
	beat_sprites["quav_c2g"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2g.png")
	beat_sprites["quav_c2a"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2a.png")
	beat_sprites["quav_c2c2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2c2.png")
	beat_sprites["quav_c2r"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_c2r.png")
	
	beat_sprites["quav_rc"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_rc.png")
	beat_sprites["quav_rd"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_rd.png")
	beat_sprites["quav_re"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_re.png")
	beat_sprites["quav_rg"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_rg.png")
	beat_sprites["quav_ra"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_ra.png")
	beat_sprites["quav_rc2"] = load("res://assets/sprites/SLOTMACHINEnotes/quav_rc2.png")
	
func random_sprite_key():
	return beat_sprites.keys().pick_random()
	
func spin_reel(reel, final_key):
	for i in range(20):
		reel.texture = beat_sprites[random_sprite_key()]
		await get_tree().create_timer(0.05).timeout
	reel.texture = beat_sprites[final_key]
	
func spin_all_reels(beat):
	var key1 = MusicLibrary.beat_to_key(beat[0])
	var key2 = MusicLibrary.beat_to_key(beat[1])
	var key3 = MusicLibrary.beat_to_key(beat[2])
	var key4 = MusicLibrary.beat_to_key(beat[3])
	
	await spin_reel(reel1, key1)
	await spin_reel(reel2, key2)
	await spin_reel(reel3, key3)
	await spin_reel(reel4, key4)

func _on_spin_pressed():
	current_bar = MusicLibrary.generate_bar()
	MusicLibrary.current_bar = current_bar
	##visual
	await spin_all_reels(current_bar)
	##audio
	await MusicLibrary.play_bar(current_bar)
	print (current_bar)
