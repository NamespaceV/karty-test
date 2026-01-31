class_name Boss
extends AnimatableBody2D

@export var boss_audiostream: AudioStreamPlayer2D

signal boss_starts_dying()
var is_dead = false

var boss_hp = MAX_HP
const MAX_HP = 10

func _ready() -> void:
	GAME.boss = self
	boss_audiostream.finished.connect(func(): update_boss_audio("none"))

func take_damage(value : int):
	if is_dead:
		return
	boss_hp -= value
	if boss_hp <= 0:
		is_dead = true
		update_boss_audio("boss_death")
		boss_starts_dying.emit()
	else:
		update_boss_audio("boss_dmg")

func update_boss_audio(audio_name: String):
	if audio_name == "none":
		boss_audiostream.stop()
	elif audio_name != boss_audiostream["parameters/switch_to_clip"]:
		boss_audiostream["parameters/switch_to_clip"] = audio_name
		boss_audiostream.play()
	else:
		boss_audiostream.play()
