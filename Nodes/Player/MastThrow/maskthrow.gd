class_name MaskThrow
extends RigidBody2D

var speed = 1000.0

var hitPfxScene = load("res://Nodes/Player/MastThrow/MaskThrowPfx.tscn")

func set_direction(dir:Vector2):
	look_at(position+dir)
	linear_velocity = dir * speed


func play_hit_particle():
	var n = hitPfxScene.instantiate() as CPUParticles2D
	n.position = global_position
	get_parent().add_child(n)
	n.emitting = true
	n.finished.connect(func():n.queue_free())

func onHit(body: Node) -> void:
	#print("mask hit", body)
	var b = body as Boss
	if b:
		b.take_damage(5)
		play_hit_particle()
	var m = body as Minon
	if m:
		m._on_body_entered(self)

	if not b and not m:
		mask_hit_SFX(global_position)

func mask_hit_SFX(pos:Vector2):
	var sfx = AudioStreamPlayer2D.new()
	sfx.position = pos
	sfx.stream = load("res://audio/mask_hit.ogg")
	sfx.max_distance = 2000
	sfx.attenuation = 1.36
	sfx.bus = &"SFX"
	sfx.finished.connect(func (): sfx.queue_free())
	add_child(sfx)
	sfx.play()
