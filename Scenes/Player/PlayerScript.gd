class_name Player

extends VBoxContainer

@export var is_in_game: bool = true
@export var is_in_round: bool = true
@export var is_players_turn: bool = false
@export var chip_count: int

signal folded

const card_scene = preload("res://Scenes/Card/Card.tscn")
const chips_scene = preload("res://Scenes/Chip/Chip.tscn")
var card_holder: HBoxContainer
var chips_holder: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_card_holder()
	_ready_chips()

## gets card holder ready for game start
func _ready_card_holder() -> void:
	card_holder = get_node("PlayerSpace/Cards")
	_add_place_holder_cards()

## gets chips ready for game start
func _ready_chips() -> void:
	chip_count = 500
	chips_holder = get_node("PlayerSpace/ChipsInfo") 
	chips_holder.get_node("ChipCount").text = str(chip_count)

## Adds empty Cards to holders
func _add_place_holder_cards() -> void:
	var place_holder_cards: Array[CardClass] = [card_scene.instantiate() as CardClass, card_scene.instantiate() as CardClass]
	_add_cards_to_card_holder(place_holder_cards)

## Adds an array of Cards to holders
func _add_cards_to_card_holder(cards: Array[CardClass]) -> void:
	if card_holder.get_children().size() > 0:
		_clear_cards()
	for card in cards:
		card_holder.add_child(card)

## Removes Cards from holders
func _clear_cards() -> void:
	for card in card_holder.get_children():
		card_holder.remove_child(card)

## When the dealer sends a signal that they have dealt cards, add them to holder
func _on_dealer_cards_to_deal(card1, card2) -> void:
	var cards: Array[CardClass] = [card1, card2]
	_add_cards_to_card_holder(cards)

## Shows the face of the card
func _show_cards() -> void:
	for card in card_holder.get_children():
		if card.value != 0:
			card._turn_card()

## Replaces Cards in holder for placeholder cards
func _fold_cards() -> void:
	_clear_cards()
	_add_place_holder_cards()
	folded.emit(self)
	
## Removes amount to be bet from chip count and places on table
func _bet_chips(amount_to_bet: int) -> void:
	var chip_inst = chips_scene.instantiate()._set_value(amount_to_bet) as Chip
	get_node("ChipSpace").add_child(chip_inst)
	chips_holder.get_node("ChipCount").text = str(int(chips_holder.get_node("ChipCount").text) - amount_to_bet)

func _on_game_manager_change_players_turn(player: Player):
	if player == self:
		is_players_turn = true
	else:
		is_players_turn = false
