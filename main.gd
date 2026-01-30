extends Node2D

@export var laser: PackedScene
@export var laser_ind: PackedScene
@onready var laser_1: Marker2D = $laserBase
var laser_offset = Vector2(350,0)
var laser_ind_array: Array
var marker_original_position: Vector2
var rng = RandomNumberGenerator.new()
var random_pos_x

func _ready() -> void:
	rng.randomize()
	marker_original_position = laser_1.global_position
	pattern1()

func _process(_delta: float) -> void:
	pass

func pattern1():
	$AnimationPlayer.play("boss_move_1")
	while true:
		[laser_show1, laser_show2].pick_random().call()
		await get_tree().create_timer(5).timeout


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



func version():
	Console.print_info("version 0.1.1")
