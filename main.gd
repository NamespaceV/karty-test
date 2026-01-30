extends Node2D

@export var laser: PackedScene
@onready var laser_1: Marker2D = $laser1
var laser_offset = Vector2(250,0)


func _ready() -> void:
	pattern1()

func pattern1():
	$AnimationPlayer.play("boss_move_1")
	while true:
		laser_show()
		await get_tree().create_timer(5).timeout

func laser_show():
	var n = 0
	for child in 10:
		if n <=6:
			var laser_spawn = laser.instantiate()
			laser_spawn.global_position = laser_1.global_position + laser_offset * n
			add_child(laser_spawn)
			n += 1

func version():
	Console.print_info("version 0.1.1")
