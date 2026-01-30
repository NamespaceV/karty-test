extends Camera2D

var hero_pos: Vector2
var mouse_pos: Vector2
var mean_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hero_pos = GAME.player.global_position
	mouse_pos = get_global_mouse_position()
	mean_pos = (hero_pos + mouse_pos)/2
	$".".global_position = mean_pos.lerp(hero_pos, 0.02*delta)
