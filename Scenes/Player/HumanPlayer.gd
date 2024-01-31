extends "res://Scenes/Player/Player.gd"

var player_card_holder

func _on_fold_pressed() -> void:
	player_card_holder = get_node("Cards")
	_clear_cards()
	_add_place_holder_cards()


func _on_cards_child_entered_tree(node):
	_show_cards()
