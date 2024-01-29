extends Node2D

var deck = preload("res://Scenes/Deck/Deck.tscn")
var table: CenterContainer 
var deck_inst: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	table = get_node("../Table/CenterOfTable")
	deck_inst = deck.instantiate()
	add_child(deck_inst)

func _input(event):
	if event.is_action_pressed("spawn"):	
		_dealCard()

func _pick_up_card():
	# Takes a random card from the deck and removes it
	var cards: Array = deck_inst.get_children()
	var selected_card: Sprite2D = cards.pick_random()
	deck_inst.remove_child(selected_card)
	return selected_card
	

func _dealCard():
	var card_to_deal: Sprite2D = _pick_up_card()
	card_to_deal._turn_card()
	table.add_child(card_to_deal)


