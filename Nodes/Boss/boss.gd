class_name Boss
extends AnimatableBody2D

@export var boss_audiostream1: AudioStreamPlayer2D
@export var boss_audiostream2: AudioStreamPlayer2D

signal boss_starts_dying()
var is_dead = false

var boss_hp = MAX_HP
const MAX_HP = 100

func _ready() -> void:
	GAME.boss = self
	#boss_audiostream1.finished.connect(func(): update_boss_audio1("none"))

func take_damage(value : int):
	if is_dead:
		return
	boss_hp -= value
	if boss_hp <= 0:
		is_dead = true
		update_boss_audio1("boss_death")
		boss_starts_dying.emit()
	else:
		update_boss_audio1("boss_dmg")
		if boss_hp < MAX_HP/2:
			$Sprite2D.texture = load("res://Nodes/Boss/boss2.png")

func update_boss_audio1(audio_name: String):
	if audio_name == "none":
		boss_audiostream1.stop()
	elif audio_name != boss_audiostream1["parameters/switch_to_clip"]:
		boss_audiostream1["parameters/switch_to_clip"] = audio_name
		boss_audiostream1.play()
	else:
		boss_audiostream1.play()

func update_boss_audio2(audio_name: String):
	if audio_name == "none":
		boss_audiostream2.stop()
	elif audio_name != boss_audiostream2["parameters/switch_to_clip"]:
		boss_audiostream2["parameters/switch_to_clip"] = audio_name
		boss_audiostream2.play()
	else:
		boss_audiostream2.play()
