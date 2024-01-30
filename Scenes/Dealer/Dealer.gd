extends Control

var deck = preload("res://Scenes/Deck/Deck.tscn")
var player 
var deck_inst

signal cards_to_deal
# Called when the node enters the scene tree for the first time.
func _ready():
	deck_inst = deck.instantiate()
	add_child(deck_inst)

func _input(event):
	if event.is_action_pressed("spawn"):
		_dealToPlayer()	

func _pick_up_card():
	# Takes a random card from the deck and removes it
	var cards: Array[Node] = deck_inst.get_children()
	var selected_card = cards.pick_random()
	deck_inst.remove_child(selected_card)
	selected_card._turn_card()
	return selected_card

func _dealToPlayer():
	cards_to_deal.emit(_pick_up_card(), _pick_up_card())
	
