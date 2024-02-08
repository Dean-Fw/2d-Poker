class_name ComputerPlayer extends Player

func _start_turn(current_min_bet: int):
	min_bet = current_min_bet
	is_players_turn = true
	_perform_random_action()
func _end_turn() -> void:
	is_players_turn = false

func _perform_random_action() -> void:
	const actions = ["bet", "fold"]
	var action = actions.pick_random()
	if action == "bet":

		_bet(min_bet - current_bet)
	elif action == "raise":
		_bet(min_bet * 2 - current_bet)
	elif action == "fold":
		_fold_cards()
