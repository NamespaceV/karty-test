extends Node2D

const BASE_SPEED = 300.0
var lifespan = 2.5

func _on_laser_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()

func _process(delta: float) -> void:
	var to_player = GAME.player.global_position - global_position
	var speed = BASE_SPEED
	if to_player.length() > 400:
		speed *= 2
	var move = to_player.normalized() * speed * delta
	position += move

	lifespan -= delta
	if lifespan <= 0:
		queue_free()
