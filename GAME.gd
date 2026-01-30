extends Node2D

func reset_game():
	call_deferred("reload")

func reload():
	get_tree().change_scene_to_file("res://main.tscn")
