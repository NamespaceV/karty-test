extends Node2D

var player : Player
var boss : Boss

var in_cutscene = false

func reset_game():
	call_deferred("reload")

func reload():
	get_tree().change_scene_to_file("res://main.tscn")

func boss_defeated():
	get_tree().change_scene_to_file("res://win.tscn")

func spawn_SFX(pos:Vector2, stream: AudioStream):
	var sfx = AudioStreamPlayer2D.new()
	sfx.global_position = pos
	sfx.stream = stream
	sfx.volume_db = 0
	sfx.max_distance = 2000
	sfx.attenuation = 0.225
	sfx.bus = &"SFX"
	sfx.finished.connect(func (): sfx.queue_free())
	get_tree().current_scene.add_child(sfx)
	sfx.play()
