extends Area2D

var hitPfxScene = load("res://Nodes/Player/MastThrow/MaskThrowPfx.tscn")
const FLY_TIME = 0.2


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		var p = body as Player
		p.wear_mask()
		queue_free()

func from_player(pos : Vector2):
	$Sprite2D.global_position = pos
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position", Vector2.ZERO, FLY_TIME)
	get_tree().create_timer(FLY_TIME).timeout.connect(play_hit_particle)


func play_hit_particle():
	var n = hitPfxScene.instantiate() as CPUParticles2D
	n.position = global_position
	get_parent().add_child(n)
	n.emitting = true
	n.finished.connect(func():n.queue_free())
