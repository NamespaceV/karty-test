extends Node2D

@export var laser: PackedScene
@export var laser_ind: PackedScene
@onready var laser_1: Marker2D = $laser1
var laser_offset = Vector2(250,0)
var laser_ind_array: Array

func _ready() -> void:
	pattern1()

func pattern1():
	$AnimationPlayer.play("boss_move_1")
	while true:
		await get_tree().create_timer(10).timeout
		laser_show()


func laser_show():
	laser_ind_array = []
	#spawn indykatorów
	var k = 0
	for child in 6:
		if k <=6:
			var indicator_spawn = laser_ind.instantiate()
			indicator_spawn.global_position = laser_1.global_position + laser_offset * k
			add_child(indicator_spawn)
			laser_ind_array.append(indicator_spawn)
			print(laser_ind_array)
			k += 1
	await get_tree().create_timer(1).timeout
	#spawn laserów
	var n = 0
	for child in 6:
		if n <=6:
			var laser_spawn = laser.instantiate()
			laser_spawn.global_position = laser_1.global_position + laser_offset * n
			add_child(laser_spawn)
			n += 1
	
	await get_tree().create_timer(2.6).timeout
	#despawn indykatorów
	for child in laser_ind_array:
		child.queue_free()
	
	
	
	
func version():
	Console.print_info("version 0.1.1")
