extends Node2D

@onready var musicManager = $WorldAudioManager

@export var orb: PackedScene
@export var minion: PackedScene
@export var aoe: PackedScene
@export var laser: PackedScene
@export var laser_ind: PackedScene
@onready var laser_1: Marker2D = $laserBase

const SKIP_INTRO = false

var laser_offset = Vector2(350,0)
var laser_ind_array: Array
var marker_original_position: Vector2
var rng = RandomNumberGenerator.new()
var phase2complete = false

var effects = [
	boss_pizza,
	laser_show1,
	laser_show2,
	aoe_show,
	aoe_show2,
	spawn_orbs,
	spawn_minions,
]

func _ready() -> void:
	rng.randomize()
	marker_original_position = laser_1.global_position

	GAME.in_cutscene = true
	if not SKIP_INTRO:
		await $AnimationPlayer.animation_finished
	GAME.in_cutscene = false
	if $boss.is_dead:
		boss_killed()
		return
	$AnimationPlayer.play("boss_move_1")
	GAME.boss.update_boss_audio2("f_indicator")
	await get_tree().create_timer(0.33).timeout
	musicManager.playBGM("boss1")
	$boss.boss_starts_dying.connect(boss_killed)
	await get_tree().create_timer(1).timeout
	pattern1()
	#beat_test()

func boss_killed():
	musicManager.playBGM("boss_dead")
	$AnimationPlayer.play("boss_dead")
	await $AnimationPlayer.animation_finished
	GAME.boss_defeated()

func beat_test():
	while true:
		var indicator_spawn = laser_ind.instantiate()
		indicator_spawn.global_position = GAME.player.global_position
		add_child(indicator_spawn)
		await musicManager.beatSync(true)
		indicator_spawn.queue_free()

func pattern1():
	$AnimationPlayer.play("boss_move_1")
	var wait = 0
	while not $boss.is_dead:
		effects.shuffle()
		for e in effects:
			e.call()
			wait += 2 if not GAME.boss.phase2 else 1
			if wait >= 2:
				await get_tree().create_timer(5).timeout
				wait = 0
			await musicManager.beatSync()
			if $boss.is_dead:
				return
			if $boss.phase2 and not phase2complete:
				await anim_phase2_transition()

func anim_phase2_transition():
	var boss = GAME.boss
	phase2complete = true
	musicManager.playBGM("transition")
	$AnimationPlayer.pause()
	var tween = get_tree().create_tween()
	var pos = boss.position
	tween.tween_property(boss, "position", pos + Vector2(0,-500), 16.0)
	var shadow = load("res://Nodes/Boss/BossShadow.tscn").instantiate()
	shadow.position = boss.position
	shadow.modulate = Color.TRANSPARENT
	add_child(shadow)
	tween = get_tree().create_tween()
	tween.tween_property(shadow, "modulate", Color.WHITE, 16.0)
	await get_tree().create_timer(16).timeout
	boss.get_node("Sprite2D").texture = load("res://Nodes/Boss/boss2.png")
	tween = get_tree().create_tween()
	tween.tween_property(boss, "position", pos , 8.0)
	tween = get_tree().create_tween()
	tween.tween_property(shadow, "modulate", Color.TRANSPARENT, 8.0)
	await get_tree().create_timer(4).timeout
	boss.turn_invincible(false)
	$AnimationPlayer.play()
	musicManager.playBGM("boss2")


func spawn_minions():
	print(" - spawn minions ",  float(Time.get_ticks_msec()) / 1000.0)

	for i in 5:
		spawn_minion(GAME.boss.position + Vector2(-100,0))
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(3).timeout
	for i in 10:
		spawn_minion(GAME.boss.position + Vector2(-100,0))
		await get_tree().create_timer(0.1).timeout

func spawn_minion(pos:Vector2):
	var m = minion.instantiate()
	m.global_position = pos
	add_child(m, true)


func spawn_orbs():
	print(" - orbs ",  float(Time.get_ticks_msec()) / 1000.0)
	for i in 8:
		spawn_orb(GAME.boss.position)
		await get_tree().create_timer(0.6).timeout

func spawn_orb(pos:Vector2):
	var m = orb.instantiate()
	m.global_position = pos
	add_child(m)

func vrand_box(size:float) -> Vector2:
	return Vector2(rng.randf_range(-size, size), rng.randf_range(-size, size))

func laser_show1():
	print(" - laser_show1 ",  float(Time.get_ticks_msec()) / 1000.0)

	var random_laser_position = marker_original_position
	random_laser_position.x +=  rng.randi_range(-300, 300)
	for i in 6:
		await musicManager.beatSync(false)
		spawnLaser(random_laser_position, Vector2(0,-1))
		spawnLaser(random_laser_position, Vector2(0,1))
		spawn_fire_indicator_SFX(random_laser_position)
		random_laser_position -= laser_offset
		await get_tree().create_timer(0.2).timeout


func laser_show2():
	print(" - laser_show2 ",  float(Time.get_ticks_msec()) / 1000.0)

	var random_laser_position = GAME.boss.position
	random_laser_position.y +=  rng.randi_range(-300, 300)
	random_laser_position.y += 350.0*6/2
	for i in 6:
		spawnLaser(random_laser_position, Vector2(-1,0))
		random_laser_position += Vector2(0,-350)
		spawn_fire_indicator_SFX(random_laser_position)
		await get_tree().create_timer(0.2).timeout

func aoe_show():
	print(" - aoe_show ",  float(Time.get_ticks_msec()) / 1000.0)

	for i in 3:
		await musicManager.beatSync(true)
		spawnAoe(GAME.player.position)

func aoe_show2():
	print(" - aoe_show2 ",  float(Time.get_ticks_msec()) / 1000.0)

	var spawn_pos = GAME.player.position
	for i in 6:
		spawnAoe(spawn_pos + vrand_box(500))

func spawnAoe(pos:Vector2):
	var indicator_spawn = laser_ind.instantiate()
	indicator_spawn.global_position = pos
	add_child(indicator_spawn)
	spawn_fire_indicator_SFX(pos)
	await get_tree().create_timer(1).timeout
	var laser_spawn = aoe.instantiate() as Node2D
	laser_spawn.global_position = pos
	add_child(laser_spawn)
	await get_tree().create_timer(1).timeout
	indicator_spawn.queue_free()

func spawnLaser(pos:Vector2, dir:Vector2):
	var indicator_spawn = laser_ind.instantiate()
	indicator_spawn.global_position = pos
	add_child(indicator_spawn)
	await get_tree().create_timer(1).timeout
	spawn_fire_spell_SFX(GAME.boss.position)
	var laser_spawn = laser.instantiate() as Node2D
	laser_spawn.global_position = pos
	laser_spawn.look_at(pos+dir)
	add_child(laser_spawn)
	await get_tree().create_timer(2.6).timeout
	indicator_spawn.queue_free()

func spawn_fire_indicator_SFX(pos:Vector2):
	var sfx = AudioStreamPlayer2D.new()
	sfx.position = pos
	sfx.stream = load("res://audio/fire_indicator.ogg")
	sfx.bus = &"SFX"
	sfx.finished.connect(func (): sfx.queue_free())
	add_child(sfx)
	sfx.play()

func spawn_fire_spell_SFX(pos:Vector2):
	var sfx = AudioStreamPlayer2D.new()
	sfx.position = pos
	sfx.stream = load("res://audio/fire_spell.ogg")
	#sfx.volume_db = 18.1
	sfx.bus = &"Fire Reverb"
	sfx.finished.connect(func (): sfx.queue_free())
	add_child(sfx)
	sfx.play()


func boss_pizza():
	print(" - boss_pizza ",  float(Time.get_ticks_msec()) / 1000.0)

	$AnimationPlayer.pause()
	#var random_laser_position = marker_original_position
	#random_laser_position.x +=  rng.randi_range(-300, 300)
	for i in 6:
		var boss_pos = GAME.boss.global_position
		var dir = GAME.player.global_position - boss_pos
		var angle = rad_to_deg(dir.angle())
		var spread = 10.0
		print(angle)
		var offset = (i - 3) * spread
		var laser_angle = deg_to_rad(angle + offset)
		var laser_dir = Vector2(cos(laser_angle), sin(laser_angle))
		spawn_fire_indicator_SFX(GAME.boss.global_position)
		spawnLaser(boss_pos, laser_dir)
		#random_laser_position += laser_offset
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play()

func version():
	Console.print_info("version 0.1.1")
