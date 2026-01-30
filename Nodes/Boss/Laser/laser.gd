extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$".".position.y -= 1000 * delta


func _on_laser_area_body_entered(body: Node2D) -> void:
	print("halo")
	if body.is_in_group("hero"):
		print("bang")
		var p = body as Player
		p.take_damage()


func _on_laser_area_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
