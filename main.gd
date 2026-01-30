extends Node2D

@export var laser: PackedScene
@export var laser_ind: PackedScene
@onready var laser_1: Marker2D = $laser1
var laser_offset = Vector2(250,0)


func _ready() -> void:
	pattern1()

func pattern1():
	$AnimationPlayer.play("boss_move_1")
	while true:
		await get_tree().create_timer(5).timeout
		laser_show()


func laser_show():
	#spawn indykatorów
	var k = 0
	for child in 6:
		if k <=6:
			var indicator_spawn = laser_ind.instantiate()
			indicator_spawn.global_position = laser_1.global_position + laser_offset * k
			add_child(indicator_spawn)
			k += 1
	await get_tree().create_timer(2).timeout
	#spawn laserów
	var n = 0
	for child in 10:
		if n <=6:
			var laser_spawn = laser.instantiate()
			var indicator_spawn = laser_ind.instantiate()
			laser_spawn.global_position = laser_1.global_position + laser_offset * n
			indicator_spawn.global_position = laser_1.global_position + laser_offset * n
			add_child(laser_spawn)
			add_child(indicator_spawn)
			n += 1

func version():
	Console.print_info("version 0.1.1")
