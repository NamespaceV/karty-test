extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	volume_update()

func volume_update():
	var master_volume = $master_soundbar
	AudioGlobal.master_volume = master_volume.value
	var music_volume = $master_soundbar/music_soundbar
	AudioGlobal.music_volume = music_volume.value
	var sfx_volume = $master_soundbar/sfx_soundbar
	AudioGlobal.sfx_volume = sfx_volume.value
	var ambience_volume = $master_soundbar/ambience_soundbar
	AudioGlobal.ambience_volume = ambience_volume.value
