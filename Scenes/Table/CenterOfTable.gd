class_name CenterOfTable extends HBoxContainer

@export var community_cards: Array[CardClass]
@export var pot: Chip

const chip_scene = preload("res://Scenes/Chip/Chip.tscn")

func _append_community_cards(card: CardClass) -> CenterOfTable:
	community_cards.append(card)
	add_child(card)
	return self

func _clear_table() -> void:
	for child in get_children(): remove_child(child) 
	community_cards = []

func _add_to_pot(amount_to_add: int) -> void:
	if has_node("Chip") == false:
		var pot_instance = chip_scene.instantiate()._set_value(amount_to_add)
		add_child(pot_instance)
		pot = pot_instance
	else:
		pot._set_value(pot.amount + amount_to_add)
		
