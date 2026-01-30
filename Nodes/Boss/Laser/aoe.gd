extends Node2D

func _on_laser_area_body_entered(body: Node2D) -> void:
	print("halo")
	if body.is_in_group("hero"):
		print("bang")
		var p = body as Player
		p.take_damage()

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(func done(name): queue_free())
