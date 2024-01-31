class_name Player

extends HBoxContainer

@export var is_in_game: bool = true
@export var is_in_round: bool = true

const card_scene = preload("res://Scenes/Card/Card.tscn")
var card_holder: HBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	card_holder = get_node("Cards")
	_add_place_holder_cards()
## Adds empty Cards to holders
func _add_place_holder_cards() -> void:
	var place_holder_cards: Array[CardClass] = [card_scene.instantiate() as CardClass, card_scene.instantiate() as CardClass]
	_add_cards_to_card_holder(place_holder_cards)
## Adds an array of Cards to holders
func _add_cards_to_card_holder(cards: Array[CardClass]):
	if card_holder.get_children().size() > 0:
		_clear_cards()
	for card in cards:
		card_holder.add_child(card)
## Removes Cards from holders
func _clear_cards():
	for card in card_holder.get_children():
		card_holder.remove_child(card)
## When the dealer sends a signal that they have dealt cards, add them to holder
func _on_dealer_cards_to_deal(card1, card2) -> void:
	var cards: Array[CardClass] = [card1, card2]
	_add_cards_to_card_holder(cards)

func _show_cards() -> void:
	for card in card_holder.get_children():
		if card.value != 0:
			card._turn_card()
