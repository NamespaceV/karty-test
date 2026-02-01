extends Node

@export var bg_music_player: AudioStreamPlayer
@export var bg_ambience_player: AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_volume()

func playAMB(track_name:String):
	if track_name == "transition":
		bg_ambience_player.stop()
	if track_name == "boss1" or track_name == "boss2":
		GAME.boss.update_boss_audio2("boss_scream")
		bg_ambience_player["parameters/switch_to_clip"] = "boss1_music"
		bg_ambience_player.play()
	elif track_name == "boss_dead":
		bg_ambience_player["parameters/switch_to_clip"] = "boss1_end"
		bg_ambience_player.play()

func playBGM(track_name:String):
	if track_name == "transition":
		bg_music_player["parameters/switch_to_clip"] = "boss1_end"
		bg_music_player.play()
	#if track_name == "boss_intro":
		#bg_music_player["parameters/switch_to_clip"] = "boss_intro"
		#bg_music_player.play()
	if track_name == "boss1":
		GAME.boss.update_boss_audio2("boss_scream")
		bg_music_player["parameters/switch_to_clip"] = "boss1_music"
		bg_music_player.play()
	elif track_name == "boss2":
		GAME.boss.update_boss_audio2("boss_scream")
		bg_music_player["parameters/switch_to_clip"] = "boss2_music"
		bg_music_player.play()
	elif track_name == "boss_dead":
		bg_music_player["parameters/switch_to_clip"] = "boss2_end"
		bg_music_player.play()



func beatSync(full = true):
	var pos = bg_music_player.get_playback_position()
	pos -= 0.1
	var time_span = (3.0 if full else 1.0) /3

	var offBeat = time_span - fmod(pos, time_span)
	await get_tree().create_timer(offBeat).timeout
	print ("beat sync %f -> %f"%[pos, bg_music_player.get_playback_position()])

func update_volume():
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var ambience_bus = AudioServer.get_bus_index("Ambience")

	AudioServer.set_bus_volume_db(master_bus, AudioGlobal.master_volume)
	AudioServer.set_bus_volume_db(music_bus, AudioGlobal.music_volume)
	AudioServer.set_bus_volume_db(sfx_bus, AudioGlobal.sfx_volume)
	AudioServer.set_bus_volume_db(ambience_bus, AudioGlobal.ambience_volume)
