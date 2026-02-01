class_name MaskThrow
extends RigidBody2D

var speed = 1000.0


func set_direction(dir:Vector2):
	look_at(position+dir)
	linear_velocity = dir * speed
