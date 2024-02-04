class_name ComputerPlayer extends Player

func _on_game_manager_change_players_turn(player: Player, current_min_bet: int):
	min_bet = current_min_bet
	
	if player == self:
		is_players_turn = true
		_perform_random_action()
	else:
		is_players_turn = false

func _perform_random_action() -> void:
	const actions = ["bet", "raise"]
	var action = actions.pick_random()
	if action == "bet":
		_bet(min_bet - current_bet)
	elif action == "raise":
		_bet(min_bet * 2 - current_bet)
	elif action == "fold":
		_fold_cards()
