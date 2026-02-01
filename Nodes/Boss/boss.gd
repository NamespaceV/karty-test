class_name Boss
extends AnimatableBody2D

@export var boss_audiostream1: AudioStreamPlayer2D
@export var boss_audiostream2: AudioStreamPlayer2D

signal boss_starts_dying()
signal phase2_start()

var is_dead = false
var phase2 = false

var boss_hp = MAX_HP
const MAX_HP = 10

var boss_invincible = false

func _ready() -> void:
	GAME.boss = self
	boss_audiostream1.finished.connect(func(): update_boss_audio2("cloth"))

func take_damage(value : int):
	if is_dead or boss_invincible:
		return
	boss_hp -= value
	if boss_hp <= 0:
		is_dead = true
		update_boss_audio1("boss_death")
		boss_starts_dying.emit()
	else:
		update_boss_audio1("boss_dmg")
		if not phase2 and boss_hp < MAX_HP/2.0:
			phase2 = true
			phase2_start.emit()
			turn_invincible(true)


func turn_invincible(on:bool):
	$Sprite2D.modulate =  Color.WEB_PURPLE  if on else Color.WHITE
	boss_invincible = on
	$Phase2TransitionPFX.emitting = on


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
