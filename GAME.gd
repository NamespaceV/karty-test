extends Node2D

var player : Player
var boss : Boss

func reset_game():
	call_deferred("reload")

func reload():
	get_tree().change_scene_to_file("res://main.tscn")
