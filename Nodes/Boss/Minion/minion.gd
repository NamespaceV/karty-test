class_name Minon
extends CharacterBody2D

var speed = 300
var lifespan = 2.5


func _on_body_entered(body: Node2D) -> void:
	print ("minion hit ", body)

	if body.is_in_group("hero"):
		var p = body as Player
		p.take_damage()
		queue_free()

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
