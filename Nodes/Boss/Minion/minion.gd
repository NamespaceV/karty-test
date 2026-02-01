class_name Minon
extends CharacterBody2D

var speed = 300
var lifespan = 2.5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()
		queue_free()
	var mask = body as MaskThrow
	if mask:
		queue_free()
		kill_all_around()
		GAME.player.wear_mask()
		GAME.player.global_position = global_position

func kill_all_around():
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 200.0
	params.shape = shape
	params.transform.origin = global_position  # Center point
	params.collision_mask = 1
	params.exclude = [self]
	var results = space_state.intersect_shape(params, 32)
	for r in results:
		var m = r["collider"] as Minon
		if m:
			m.queue_free()

func take_dmage(_dmg:float):
	queue_free()

func _physics_process(_delta: float) -> void:
	var to_player = GAME.player.global_position - global_position
	velocity = to_player.normalized() * speed
	$Minion.flip_h = velocity.x <= 0
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		_on_body_entered(collider)
