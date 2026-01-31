extends CanvasLayer


func _process(delta: float) -> void:
	$Stamina.max_value = GAME.player.MAX_STAMINA
	$Stamina.value = GAME.player.stamina
	$BossHp.max_value = GAME.boss.MAX_HP
	$BossHp.value = GAME.boss.boss_hp
