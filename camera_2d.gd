extends Camera2D

var hero_pos: Vector2
var mouse_pos: Vector2
var mean_pos: Vector2

@export var bg:Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hero_pos = GAME.player.global_position
	mouse_pos = get_global_mouse_position()
	mean_pos = (hero_pos + mouse_pos)/2
	var r = bg.get_rect()
	r.position += bg.position
	var goal_pos = clampToRect(mean_pos, r)
	$".".global_position = lerp(global_position, goal_pos, 8*delta)

func clampToRect(p:Vector2, r:Rect2) -> Vector2:
	var result = p
	result.x = clamp(p.x, r.position.x, r.end.x)
	result.y = clamp(p.y, r.position.y, r.end.y)
	return result
