class_name HumanPlayer extends "res://Scenes/Player/PlayerScript.gd"

var player_card_holder

func _on_fold_pressed() -> void:
	_fold_cards()

func _on_cards_child_entered_tree(node: CardClass) -> void:
	_show_cards()

func _on_bet_or_raise_pressed() -> void:
	_bet_chips(5)

func _on_game_manager_change_players_turn(player: Player):
	if player == self:
		get_node("PlayerSpace/HumanActions/BetOrRaise").disabled = false
		get_node("PlayerSpace/HumanActions/HBoxContainer2/Check").disabled = false
		get_node("PlayerSpace/HumanActions/HBoxContainer2/Fold").disabled = false
	else:
		get_node("PlayerSpace/HumanActions/BetOrRaise").disabled = true
		get_node("PlayerSpace/HumanActions/HBoxContainer2/Check").disabled = true
		get_node("PlayerSpace/HumanActions/HBoxContainer2/Fold").disabled = true
