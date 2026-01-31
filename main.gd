extends Node2D


@onready var boss: Boss = $boss
@onready var player: Player = $Player


@export var minion: PackedScene
@export var aoe: PackedScene
@export var laser: PackedScene
@export var laser_ind: PackedScene
@onready var laser_1: Marker2D = $laserBase
var laser_offset = Vector2(350,0)
var laser_ind_array: Array
var marker_original_position: Vector2
var rng = RandomNumberGenerator.new()

var effects = [
	boss_pizza,
	laser_show1,
	#laser_show2,
	#aoe_show,
	#aoe_show2,
	#spawn_minions
]

func _ready() -> void:
	rng.randomize()
	marker_original_position = laser_1.global_position
	pattern1()


func pattern1():
	$AnimationPlayer.play("boss_move_1")
	while true:
		effects.shuffle()
		for e in effects:
			e.call()
			await get_tree().create_timer(5).timeout

func spawn_minions():
	for i in 2:
		spawn_minion(GAME.boss.position)
		await get_tree().create_timer(0.5).timeout

func spawn_minion(pos:Vector2):
	var m = minion.instantiate()
	m.global_position = pos
	add_child(m)

func laser_show1():
	var random_laser_position = marker_original_position
	random_laser_position.x +=  rng.randi_range(-300, 300)
	for i in 6:
		spawnLaser(random_laser_position, Vector2(0,-1))
		random_laser_position += laser_offset
		await get_tree().create_timer(0.2).timeout


func laser_show2():
	var random_laser_position = marker_original_position
	random_laser_position.y +=  rng.randi_range(-300, 300)
	for i in 6:
		spawnLaser(random_laser_position, Vector2(1,0))
		random_laser_position += Vector2(0,-350)
		await get_tree().create_timer(0.2).timeout

func aoe_show():
	var spawn_pos = marker_original_position
	for i in 10:
		var randv = Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))
		spawnAoe(spawn_pos + randv)
		spawn_pos += Vector2(350,-350)

func aoe_show2():
	var spawn_pos = marker_original_position + Vector2(350 * 3, 0)
	for i in 10:
		var randv = Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))
		spawnAoe(spawn_pos + randv)
		spawn_pos += Vector2(-350,-350)

func spawnAoe(pos:Vector2):
	var indicator_spawn = laser_ind.instantiate()
	indicator_spawn.global_position = pos
	add_child(indicator_spawn)
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
	var laser_spawn = laser.instantiate() as Node2D
	laser_spawn.global_position = pos
	laser_spawn.look_at(pos+dir)
	add_child(laser_spawn)
	await get_tree().create_timer(2.6).timeout
	indicator_spawn.queue_free()


func boss_pizza():
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
		spawnLaser(boss_pos, laser_dir)
		#random_laser_position += laser_offset
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play()

func version():
	Console.print_info("version 0.1.1")
