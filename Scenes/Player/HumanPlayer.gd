class_name HumanPlayer extends Player

var player_card_holder

func _on_fold_pressed() -> void:
	_fold_cards()

func _on_cards_child_entered_tree(node: CardClass) -> void:
	_show_cards()

func _on_bet_pressed() -> void:
	_bet(min_bet - current_bet)

func _on_raise_pressed() -> void:
	_bet(min_bet * 2)

func _on_game_manager_change_players_turn(player: Player, current_min_bet: int) -> void:
	min_bet = current_min_bet
	if player == self:
		is_players_turn = true
		_change_action_buttons_disabled(false)
		_change_bet_buttons_text_to_have_value()
	else:
		is_players_turn = false
		_change_action_buttons_disabled(true)
		_change_bet_buttons_text_to_have_value()

func _change_bet_buttons_text_to_have_value() -> void:
	var buttons = [get_node("PlayerSpace/HumanActions/Bet"), get_node("PlayerSpace/HumanActions/Raise")] as Array[Button]
	if is_players_turn == true:
		buttons[0].text = buttons[0].text + " (%s)" % str(min_bet)
		buttons[1].text = buttons[1].text + " (%s)" % str(min_bet * 2)
	else:
		buttons[0].text = "Bet"
		buttons[1].text = "raise"

func _change_action_buttons_disabled(state: bool) -> void:
	for button in get_node("PlayerSpace/HumanActions").get_children() as Array[Button]:
		button.disabled = state
		
func _change_bet_buttons_value() -> void:
	get_node("PlayerSpace/HumanActions/Bet").text.append()



