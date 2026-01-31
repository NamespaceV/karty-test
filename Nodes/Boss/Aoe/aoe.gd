extends Node2D

func _on_laser_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()


func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(func done(_name): queue_free())
