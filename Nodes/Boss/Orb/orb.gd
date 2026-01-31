extends Node2D

var speed = 300
var lifespan = 2.5

func _on_laser_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()

func _process(delta: float) -> void:
	var to_player = GAME.player.global_position - global_position
	var move = to_player.normalized() * speed * delta
	position += move

	lifespan -= delta
	if lifespan <= 0:
		queue_free()
