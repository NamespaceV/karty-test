class_name Player
extends CharacterBody2D

@export var speed : float = 600.0
@onready var ability_1_timer: Timer = $ability_1_timer
@onready var ability_2_timer: Timer = $ability_2_timer
var ability1_on: bool
var ability2_on: bool
var dash_direction: Vector2 = Vector2.ZERO

var hasMask:bool = true

var bulletScene : PackedScene = load("res://Nodes/Player/Bullet/bullet.tscn")
var maskScene : PackedScene = load("res://Nodes/Player/Mask/Mask.tscn")

func _ready() -> void:
	ability1_on = false
	ability2_on = false
	GAME.player = self

func _process(_delta: float) -> void:
	if ability2_on == false:
		var i = Input.get_vector("left", "right", "up", "down")
		velocity = i.normalized() * speed
	else:
		velocity = Vector2.ZERO
		await get_tree().create_timer(0.3).timeout
		velocity = dash_direction * 1000
	
	
	if ability1_on:
		speed = 1200
	else:
		speed = 600

	if Input.is_action_just_pressed("atack"):
		var mosepos = get_global_mouse_position()
		var to_mouse = mosepos - global_position
		var dir = to_mouse.normalized()
		var bullet : Node2D = bulletScene.instantiate()
		bullet.global_position = self.global_position
		bullet.set_direction(dir)
		get_parent().add_child(bullet, true)
		
	if Input.is_action_just_pressed("ability1"):
		$ability_1_timer.start()
		ability1_on = true
	if Input.is_action_just_pressed("ability2"):
		ability_2_timer.start()
		var mouse_pos = get_global_mouse_position()
		dash_direction = (mouse_pos - global_position).normalized()
		ability2_on = true
	
	move_and_slide()



func take_damage():
	if not hasMask:
		GAME.reset_game()
	hasMask = false
	$AnimationPlayer.play("no_mask")
	call_deferred("spawn_mask")

func spawn_mask():
	var mask : Node2D = maskScene.instantiate()
	var offset = Vector2(300, 0).rotated(randf() * TAU)
	mask.global_position = self.global_position + offset
	get_parent().add_child(mask, true)

func wear_mask():
	hasMask = true
	$AnimationPlayer.play("RESET")


func _on_ability_1_timer_timeout() -> void:
	ability1_on = false


func _on_ability_2_timer_timeout() -> void:
	ability2_on = false
