class_name MaskThrow
extends RigidBody2D

var speed = 1000.0


func set_direction(dir:Vector2):
	look_at(position+dir)
	linear_velocity = dir * speed


func onHit(body: Node) -> void:
	#print("mask hit", body)
	var b = body as Boss
	if b:
		b.take_damage(5)

func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	onHit(body)
