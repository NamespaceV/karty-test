extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.wear_mask()
		queue_free()

func from_player(pos : Vector2):
	$Sprite2D.global_position = pos
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position", Vector2.ZERO, 0.2)
