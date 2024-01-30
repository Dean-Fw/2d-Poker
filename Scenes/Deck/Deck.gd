extends Control

class_name Deck

const suits = ["hearts", "clubs", "diamonds", "spades"]

var card = preload("res://Scenes/Card/Card.tscn")
# Called when the node enters the scene tree for the first time.
func _init():
	for suit in suits:
		for value in range (1,14):
			var new_card = card.instantiate()
			new_card.suit = suit
			new_card.value = value
			add_child(new_card)
			
	

