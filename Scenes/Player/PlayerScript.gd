class_name Player

extends VBoxContainer

@export var is_in_game: bool = true
@export var is_in_round: bool = true
@export var is_players_turn: bool = false
@export var chip_count: int
@export var player_hand: Array[CardClass]

signal folded
signal betted(player: Player, new_min_bet: int)
signal checked

const card_scene = preload("res://Scenes/Card/Card.tscn")
const chips_scene = preload("res://Scenes/Chip/Chip.tscn")
var card_holder: HBoxContainer
var chips_holder: VBoxContainer

@export var min_bet: int
@export var current_bet: int
# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_card_holder()
	chips_holder = get_node("PlayerSpace/ChipsInfo") 
	_set_chip_count(500)

## gets card holder ready for game start
func _ready_card_holder() -> void:
	card_holder = get_node("PlayerSpace/Cards")
	_add_place_holder_cards()

## gets chips ready for game start
func _set_chip_count(new_chip_count:int) -> Player:
	chip_count = new_chip_count
	chips_holder.get_node("ChipCount").text = str(chip_count)
	return self

func _set_player_hand(cards: Array[CardClass]) -> Player:
	_add_cards_to_card_holder(cards)
	return self

## Adds empty Cards to holders
func _add_place_holder_cards() -> void:
	var place_holder_cards: Array[CardClass] = [card_scene.instantiate() as CardClass, card_scene.instantiate() as CardClass]
	_set_player_hand(place_holder_cards)

## Adds an array of Cards to holders
func _add_cards_to_card_holder(cards: Array[CardClass]) -> void:
	if card_holder.get_children().size() > 0:
		_clear_cards()
	for card in cards:
		player_hand = cards
		card_holder.add_child(card)

## Removes Cards from holders
func _clear_cards() -> void:
	for card in card_holder.get_children():
		card_holder.remove_child(card)
	player_hand = []

## When the dealer sends a signal that they have dealt cards, add them to holder
func _on_dealer_cards_to_deal(card1, card2) -> void:
	var cards: Array[CardClass] = [card1, card2]
	_set_player_hand(cards)

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
	if get_node("ChipSpace").has_node("Chip"):
		var chip = get_node("ChipSpace/Chip") as Chip
		chip._set_value(chip.amount + amount_to_bet)
	else:
		var chip_inst = chips_scene.instantiate()._set_value(amount_to_bet) as Chip
		get_node("ChipSpace").add_child(chip_inst)
	chips_holder.get_node("ChipCount").text = str(int(chips_holder.get_node("ChipCount").text) - amount_to_bet)
	chip_count -= amount_to_bet
	current_bet += amount_to_bet
	
func _bet(amount_to_bet) -> void:
	_bet_chips(amount_to_bet)
	betted.emit(get_node("ChipSpace/Chip").amount)

