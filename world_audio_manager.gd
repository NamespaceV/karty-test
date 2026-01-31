extends Node

@export var bg_music_player: AudioStreamPlayer
@export var bg_ambience_player: AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func playBGM(name:String):
	#if name == "boss_intro":
		#bg_music_player["parameters/switch_to_clip"] = "boss_intro"
		#bg_music_player.play()
	if name == "boss1":
		bg_music_player["parameters/switch_to_clip"] = "boss_music"
		bg_music_player.play()
	elif name == "boss_dead":
		bg_music_player["parameters/switch_to_clip"] = "boss_end"
		bg_music_player.play()


func beatSync(full = true):
	var pos = bg_music_player.get_playback_position()
	pos -= 0.1
	var time_span = (3.0 if full else 1.0) /3

	var offBeat = time_span - fmod(pos, time_span)
	await get_tree().create_timer(offBeat).timeout
	print ("beat sync %f -> %f"%[pos, bg_music_player.get_playback_position()])
