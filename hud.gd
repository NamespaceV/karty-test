extends CanvasLayer


func _process(_delta: float) -> void:
	$Stamina.max_value = GAME.player.MAX_STAMINA
	$Stamina.value = GAME.player.stamina
	$BossHp.max_value = GAME.boss.MAX_HP
	$BossHp.value = GAME.boss.boss_hp


func _on_settings_button_pressed() -> void:
	$"Settings Menu".visible = not $"Settings Menu".visible
	get_tree().paused = $"Settings Menu".visible
