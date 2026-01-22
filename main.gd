extends Node2D

var card_scene = load("res://Nodes/Card/card.tscn") as PackedScene

func _ready() -> void:
	$ShuffleButton.pressed.connect(shuffle)
	$PlaySound.pressed.connect(play_sound)
	shuffle()

func shuffle():
	print_debug("shuffle")
	for c in $Cards.get_children():
		c.queue_free()
	for i in 10:
		var card = card_scene.instantiate() as Card
		card.suit = randi_range(Card.Suit.heart, Card.Suit.club)
		card.value = randi_range(2, Card.ACE)
		card.position = Vector2(100*(i+1), 100)
		$Cards.add_child(card)

func play_sound():
	$FmodEventEmitter2D.play()
