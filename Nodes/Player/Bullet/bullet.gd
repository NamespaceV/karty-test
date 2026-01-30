extends AnimatableBody2D

var speed = 1000.0

func _ready() -> void:
	sync_to_physics = false

func set_direction(dir:Vector2):
	look_at(position+dir)


func _process(delta: float) -> void:

	var collision = move_and_collide(Vector2(1, 0).rotated(rotation) * speed * delta)
	if collision:
		var hit = collision.get_collider()
		print("hit %s" % [hit])
		queue_free()
		var boss = hit as Boss
		if boss:
			boss.take_damage(1)

	if !$VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()
