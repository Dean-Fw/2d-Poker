extends Control

class_name Deck

const suits = ["hearts", "clubs", "diamonds", "spades"]

var card = preload("res://Scenes/Card/Card.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for suit in suits:
		for value in range (1,14):
			var new_card = card.instantiate() as CardClass
			new_card._set_suit(suit)._set_value(value)._set_texture()
			add_child(new_card)
			
	

