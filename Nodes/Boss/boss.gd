class_name Boss
extends AnimatableBody2D

@export var hpBar : ProgressBar

func _ready() -> void:
	hpBar.max_value = 300
	hpBar.value = 300
	GAME.boss = self


func take_damage(value : int):
	hpBar.value -= value
	if hpBar.value <= 0:
		GAME.boss_defeated()
