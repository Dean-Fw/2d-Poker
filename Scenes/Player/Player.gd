extends HBoxContainer

const card_scene = preload("res://Scenes/Card/Card.tscn")
var card_holder
# Called when the node enters the scene tree for the first time.
func _ready():
	card_holder = get_node("Cards")
	_add_place_holder_cards()

func _add_place_holder_cards():
	var place_holder_cards = [card_scene.instantiate(), card_scene.instantiate()]
	_add_cards_to_card_holder(place_holder_cards)

func _add_cards_to_card_holder(cards: Array):
	if card_holder.get_children().size() > 0:
		_clear_cards()
	for card in cards:
		card_holder.add_child(card)

func _clear_cards():
	for card in card_holder.get_children():
		card_holder.remove_child(card)

func _on_dealer_cards_to_deal(card1, card2):
	var cards = [card1, card2]
	_add_cards_to_card_holder(cards)

func _on_fold_pressed():
	_add_place_holder_cards()
