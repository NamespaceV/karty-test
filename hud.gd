extends CanvasLayer


func _process(delta: float) -> void:
	$Stamina.max_value = GAME.player.MAX_STAMINA
	$Stamina.value = GAME.player.stamina
