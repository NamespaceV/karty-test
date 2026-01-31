extends Node2D

var speed = 1000

func _ready() -> void:
	var tween = get_tree().create_tween()
	scale = Vector2(0,1)
	tween.tween_property($".", "scale", Vector2.ONE, $ColorRect.size.y/speed)
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += Vector2(1.0, 0.0).rotated(rotation) * speed * delta


func _on_laser_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()


func _on_laser_area_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
