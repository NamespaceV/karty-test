class_name Player
extends CharacterBody2D

@export var speed : float = BASE_SPEED
@export var player_audiostream: AudioStreamPlayer2D

var stamina = MAX_STAMINA
const STAMINA_REGEN = 20.0
const MAX_STAMINA = 100.0

const BASE_SPEED = 600.0

var dash_on: bool
var DASH_STAMINA_COST = 45
const DASH_DURATION = 0.175
const ABILITY_1_SPEED = 2400
var dash_direction = Vector2(0,0)

const SHOOT_STAMINA_COST = 10
const SHOOT_CD = 0.3
var shoot_cooldown = 0.0

var heavy_attack_on: bool
var heavy_attack_direction: Vector2 = Vector2.ZERO
var heavy_attack_time = 0.0
const HEAVY_ATTACK_SPEED = 2400
const HEAVY_ATTACK_DELAY = 0.3
const HEAVY_ATTACK_DURATION = 0.2

const INVULNERABLE_AFTER_LOSING_MASK = 0.1

var invulnerable_time = 0

var hasMask:bool = true

var bulletScene : PackedScene = load("res://Nodes/Player/Bullet/bullet.tscn")
var maskScene : PackedScene = load("res://Nodes/Player/Mask/Mask.tscn")
var maskthrowScene : PackedScene = load("res://Nodes/Player/MastThrow/MaskThrow.tscn")

@onready var footstepSFX : AudioStreamPlayer2D = $FootstepAudio

func _ready() -> void:
	dash_on = false
	heavy_attack_on = false
	GAME.player = self


func _process(delta: float) -> void:

	if GAME.in_cutscene:
		footstepSFX.stream_paused = true
		return

	stamina += delta * STAMINA_REGEN
	if stamina > MAX_STAMINA:
		stamina = MAX_STAMINA

	shoot_cooldown -= delta
	invulnerable_time -= delta

	if heavy_attack_on:
		heavy_attack_time += delta
		velocity = Vector2.ZERO if heavy_attack_time < HEAVY_ATTACK_DELAY else \
			heavy_attack_direction * HEAVY_ATTACK_SPEED
		if heavy_attack_time > HEAVY_ATTACK_DELAY+HEAVY_ATTACK_DURATION:
			heavy_attack_on = false
	elif dash_on:
		speed = ABILITY_1_SPEED
		velocity = dash_direction * speed
		footstepSFX.stream_paused = true
	else:
		speed = BASE_SPEED
		var i = Input.get_vector("left", "right", "up", "down")
		velocity = i.normalized() * speed
		if i.is_zero_approx():
			footstepSFX.stream_paused = true
		else:
			footstepSFX.stream_paused = false
			#print("footstep")

	if Input.is_action_pressed("atack") && shoot_cooldown < 0\
			&& stamina >= SHOOT_STAMINA_COST:
		stamina -= SHOOT_STAMINA_COST
		shoot_cooldown = SHOOT_CD
		update_player_audio("dagger")
		var mosepos = get_global_mouse_position()
		var to_mouse = mosepos - global_position
		var dir = to_mouse.normalized()
		var bullet : Node2D = bulletScene.instantiate()
		bullet.global_position = self.global_position
		bullet.set_direction(dir)
		get_parent().add_child(bullet, true)

	if Input.is_action_just_pressed("throw_mask") and hasMask:
		var mosepos = get_global_mouse_position()
		var to_mouse = mosepos - global_position
		var dir = to_mouse.normalized()
		var mask : Node2D = maskthrowScene.instantiate()
		mask.global_position = self.global_position + dir * 200
		mask.set_direction(dir)
		get_parent().add_child(mask, true)
		hasMask = false
		update_player_audio("dagger")
		stamina = MAX_STAMINA
	update_animation_state()

func update_animation_state():
	$Sprite2D.flip_h = false
	if hasMask:
		if velocity.y > 10:
			$AnimationPlayer.play("go_down")
		else:
			$AnimationPlayer.play("right")
			$Sprite2D.flip_h = velocity.x < 0
	else:
		if velocity.y > 10:
			$AnimationPlayer.play("go_down_no_mask")
		else:
			$AnimationPlayer.play("right_no_mask")
			$Sprite2D.flip_h = velocity.x < 0






	if Input.is_action_just_pressed("dash") \
			&& not velocity.is_zero_approx():
		if stamina < DASH_STAMINA_COST:
			update_player_audio("no_dash")
		else:
			stamina -= DASH_STAMINA_COST
			get_tree().create_timer(DASH_DURATION).timeout.connect(
				func (): dash_on = false
			)
			dash_on = true
			update_player_audio("dash")
			dash_direction = velocity.normalized()

	if Input.is_action_just_pressed("ability2") && not heavy_attack_on:
		heavy_attack_on = true
		heavy_attack_time = 0.0
		var mouse_pos = get_global_mouse_position()
		heavy_attack_direction = (mouse_pos - global_position).normalized()

	move_and_slide()

	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var m = col.get_collider() as MaskThrow
		if m:
			m.queue_free()
			wear_mask()



func take_damage():
	if invulnerable_time > 0:
		return
	invulnerable_time = INVULNERABLE_AFTER_LOSING_MASK
	if not hasMask:

		GAME.reset_game()
		return
	hasMask = false
	call_deferred("spawn_mask")

func spawn_mask():
	var mask : Node2D = maskScene.instantiate()
	var offset = Vector2(300, 0).rotated(randf() * TAU)
	mask.global_position = self.global_position + offset
	get_parent().add_child(mask, true)
	mask.from_player(global_position)
	spawn_mask_SFX(global_position)

func wear_mask():
	hasMask = true
	stamina = MAX_STAMINA


func _on_ability_1_timer_timeout() -> void:
	dash_on = false


func _on_ability_2_timer_timeout() -> void:
	heavy_attack_on = false

func spawn_mask_SFX(pos:Vector2):
	var sfx = AudioStreamPlayer2D.new()
	sfx.position = pos
	sfx.stream = load("res://audio/mask_drop.ogg")
	sfx.volume_db = 10
	sfx.bus = &"SFX"
	sfx.finished.connect(func (): sfx.queue_free())
	add_child(sfx)
	sfx.play()

func update_player_audio(audio_name: String):
	if audio_name == "none":
		player_audiostream.stop()
	elif audio_name != player_audiostream["parameters/switch_to_clip"]:
		player_audiostream["parameters/switch_to_clip"] = audio_name
		player_audiostream.play()
	else:
		player_audiostream.play()
