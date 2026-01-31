class_name Boss
extends AnimatableBody2D

@export var hpBar : ProgressBar
@export var boss_audiostream: AudioStreamPlayer2D

signal boss_starts_dying()
var is_dead = false

func _ready() -> void:
	hpBar.max_value = 10
	hpBar.value = 10
	GAME.boss = self

func take_damage(value : int):
	if is_dead:
		return
	hpBar.value -= value
	if hpBar.value <= 0:
		is_dead = true
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
