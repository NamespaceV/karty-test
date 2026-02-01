extends Node2D

var speed = 1000
const LENGTH = 2600.0

func _ready() -> void:
	var tween = get_tree().create_tween()
	scale = Vector2(0,1)
	tween.tween_property(self, "scale", Vector2.ONE,LENGTH/speed)


func _process(delta: float) -> void:
	position += Vector2(1.0, 0.0).rotated(rotation) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()
