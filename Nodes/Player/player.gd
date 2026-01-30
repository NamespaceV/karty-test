extends CharacterBody2D

@export var speed : float = 400.0

func _process(_delta: float) -> void:
	var i = Input.get_vector("left", "right", "up", "down")
	velocity = i * speed
	move_and_slide()
