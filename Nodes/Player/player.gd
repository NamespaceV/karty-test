class_name Player
extends CharacterBody2D

@export var speed : float = BASE_SPEED
@onready var ability_1_timer: Timer = $ability_1_timer

const BASE_SPEED = 600.0
var ability1_on: bool
var ability1_cooldown = 0.0
const ABILITY_1_CD = 0.75
const ABILITY_1_SPEED = 2400
var dash_direction = Vector2(0,0)

const SHOOT_CD = 0.5
var shoot_cooldown = 0.0

var heavy_attack_on: bool
var heavy_attack_direction: Vector2 = Vector2.ZERO
var heavy_attack_time = 0.0
const HEAVY_ATTACK_SPEED = 2400
const HEAVY_ATTACK_DELAY = 0.3
const HEAVY_ATTACK_DURATION = 0.2

var invulnerable_time = 0

var hasMask:bool = true

var bulletScene : PackedScene = load("res://Nodes/Player/Bullet/bullet.tscn")
var maskScene : PackedScene = load("res://Nodes/Player/Mask/Mask.tscn")

func _ready() -> void:
	ability1_on = false
	heavy_attack_on = false
	GAME.player = self

func _process(delta: float) -> void:
	ability1_cooldown -= delta
	shoot_cooldown -= delta
	invulnerable_time -= delta

	if heavy_attack_on:
		heavy_attack_time += delta
		velocity = Vector2.ZERO if heavy_attack_time < HEAVY_ATTACK_DELAY else \
			heavy_attack_direction * HEAVY_ATTACK_SPEED
		if heavy_attack_time > HEAVY_ATTACK_DELAY+HEAVY_ATTACK_DURATION:
			heavy_attack_on = false
	elif ability1_on:
		speed = ABILITY_1_SPEED
		velocity = dash_direction * speed
	else:
		speed = BASE_SPEED
		var i = Input.get_vector("left", "right", "up", "down")
		velocity = i.normalized() * speed

	if Input.is_action_pressed("atack") && shoot_cooldown < 0:
		shoot_cooldown = SHOOT_CD
		var mosepos = get_global_mouse_position()
		var to_mouse = mosepos - global_position
		var dir = to_mouse.normalized()
		var bullet : Node2D = bulletScene.instantiate()
		bullet.global_position = self.global_position
		bullet.set_direction(dir)
		get_parent().add_child(bullet, true)

	if Input.is_action_just_pressed("ability1") && ability1_cooldown < 0 \
			&& not velocity.is_zero_approx():
		ability1_cooldown = ABILITY_1_CD
		$ability_1_timer.start()
		ability1_on = true
		dash_direction = velocity.normalized()

	if Input.is_action_just_pressed("ability2") && not heavy_attack_on:
		heavy_attack_on = true
		heavy_attack_time = 0.0
		var mouse_pos = get_global_mouse_position()
		heavy_attack_direction = (mouse_pos - global_position).normalized()

	move_and_slide()
	$Sprite2D.flip_h = velocity.x < 0



func take_damage():
	if invulnerable_time > 0:
		return
	invulnerable_time = 0.1
	if not hasMask:
		GAME.reset_game()
		return
	hasMask = false
	$AnimationPlayer.play("no_mask")
	call_deferred("spawn_mask")

func spawn_mask():
	var mask : Node2D = maskScene.instantiate()
	var offset = Vector2(300, 0).rotated(randf() * TAU)
	mask.global_position = self.global_position + offset
	get_parent().add_child(mask, true)
	mask.from_player(global_position)

func wear_mask():
	hasMask = true
	$AnimationPlayer.play("RESET")


func _on_ability_1_timer_timeout() -> void:
	ability1_on = false


func _on_ability_2_timer_timeout() -> void:
	heavy_attack_on = false
