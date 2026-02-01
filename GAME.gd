extends Node2D

var player : Player
var boss : Boss

var in_cutscene = false

func _ready() -> void:
	Console.add_command("god", god_mode)
	Console.add_command("mask", return_mask)

func god_mode():
	player.turn_on_god_mode()

func return_mask():
	player.wear_mask()

func player_died():
	var tree = get_tree()
	tree.current_scene.get_node("HUD").show_death()
	get_tree().paused = true
	var sfx = spawn_SFX(player.position, load("res://audio/player_death.wav"))
	sfx.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(2).timeout.connect(func ():
		tree.paused = false
		call_deferred("reload")
	)

func reload():
	get_tree().change_scene_to_file("res://main.tscn")

func boss_defeated():
	get_tree().change_scene_to_file("res://win.tscn")

func spawn_SFX(pos:Vector2, stream: AudioStream) -> AudioStreamPlayer2D:
	var sfx = AudioStreamPlayer2D.new()
	sfx.global_position = pos
	sfx.stream = stream
	sfx.volume_db = 0
	sfx.max_distance = 2000
	if stream == load("res://audio/monster_death.ogg"):
		sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.attenuation = 0.225
	sfx.bus = &"SFX"
	sfx.finished.connect(func (): sfx.queue_free())
	get_tree().current_scene.add_child(sfx)
	sfx.play()
	return sfx
