extends Control

var deck = preload("res://Scenes/Deck/Deck.tscn")
var players: Array[Node]
var deck_inst
# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_node("../Players").get_children() as Array[Node]
	deck_inst = deck.instantiate() as Deck
	add_child(deck_inst)

func _input(event) -> void:
	if event.is_action_pressed("spawn"):
		_dealToPlayers()	

func _pick_up_card() -> CardClass:
	# Takes a random card from the deck and removes it
	var cards: Array[Node]= deck_inst.get_children()
	var selected_card = cards.pick_random()
	deck_inst.remove_child(selected_card)
	return selected_card as CardClass

func _dealToPlayers() -> void:
	for player in players as Array[Player]:
		if player.is_in_round and player.is_in_game:
			player._add_cards_to_card_holder([_pick_up_card(), _pick_up_card()])
