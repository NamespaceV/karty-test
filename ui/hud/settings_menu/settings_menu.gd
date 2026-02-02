extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	volume_update()

func volume_update():
	var master_volume = $VBoxContainer/master_soundbar
	AUDIO_GLOBAL.master_volume = master_volume.value
	var music_volume = $VBoxContainer/music_soundbar
	AUDIO_GLOBAL.music_volume = music_volume.value
	var sfx_volume = $VBoxContainer/sfx_soundbar
	AUDIO_GLOBAL.sfx_volume = sfx_volume.value
	var ambience_volume = $VBoxContainer/ambience_soundbar
	AUDIO_GLOBAL.ambience_volume = ambience_volume.value
