extends Node2D

var card_scene = load("res://Nodes/Card/card.tscn") as PackedScene
@onready var bubble_sound: AudioStreamPlayer2D = $fish_button/bubble_sound
@onready var bubble_particles: CPUParticles2D = $fish_button/bubble_particles

func _ready() -> void:
	$DealButton.pressed.connect(deal)
	$ShuffleButton.pressed.connect(shuffle)
	bubble_particles.emitting = false
	deal()

func deal():
	print_debug("deal")
	for c in $Cards.get_children():
		c.queue_free()
	for i in 10:
		var card = card_scene.instantiate() as Card
		card.suit = randi_range(Card.Suit.heart, Card.Suit.club)
		card.value = randi_range(2, Card.ACE)
		card.position = Vector2(175*(i+1), 300)
		card.scale = Vector2(1,1)*2
		$Cards.add_child(card)
	$Deal.play()

func shuffle():
	$Shuffle.play()


func _on_fish_button_pressed() -> void:
	bubble_particles.show()
	bubble_particles.emitting = true
	bubble_sound.play()


func _on_bubble_sound_finished() -> void:
	bubble_particles.emitting = false
