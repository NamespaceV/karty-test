extends Sprite2D

enum Suit{
	heart,
	diamand,
	spade,
	club,
}

const JACK:int = 11
const QUEEN:int = 12
const KING:int = 13
const ACE:int = 14

@export var suit:Suit
@export var value:int


func _ready() -> void:
	update_sprite()

func update_sprite():
	const w = 48.0
	const h = 64.0
	var value_idx = (value + 12) % 13
	$".".region_rect = Rect2(value_idx * w, suit * h, w, h)
	var error = value < 2 or value > ACE or suit < 0 or suit > Suit.club
	$".".modulate = Color.RED if error else Color.WHITE
