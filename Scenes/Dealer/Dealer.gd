class_name Dealer

extends Control

var deck = preload("res://Scenes/Deck/Deck.tscn")
var center_of_table: HBoxContainer
var deck_inst
# Called when the node enters the scene tree for the first time.
func _ready():
	center_of_table = get_node("../CenterOfTable")
	deck_inst = deck.instantiate() as Deck
	add_child(deck_inst)

func _pick_up_card() -> CardClass:
	# Takes a random card from the deck and removes it
	var cards: Array[Node]= deck_inst.get_children()
	var selected_card = cards.pick_random() 
	deck_inst.remove_child(selected_card)
	return selected_card as CardClass

func _dealToPlayers(active_players: Array[Player]) -> void:
	for player in active_players as Array[Player]:
		player._add_cards_to_card_holder([_pick_up_card(), _pick_up_card()])

func _deal_to_table(amount_of_cards_to_deal: int):
	for card in range(amount_of_cards_to_deal):
		var card_to_deal = _pick_up_card()
		card_to_deal._turn_card()
		center_of_table.add_child(card_to_deal)
		
		
