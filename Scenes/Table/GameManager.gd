class_name GameManager

extends Control

signal change_players_turn(current_player: Player, current_min_bet: int)

var active_players: Array[Player]
var current_player: Player
var current_player_index: int = 0
var current_blind: int = 5
var current_min_bet: int

var role_manager: RoleManager
var dealer: Dealer

var center_of_table: CenterOfTable

func _ready():
	center_of_table = get_node("../CenterOfTable") as CenterOfTable
	dealer = get_node("../Dealer") as Dealer
	_set_active_players()
	role_manager = RoleManager.new(active_players)
	_start_round()
	
func _start_round() -> void:
	_gather_blinds()
	dealer._dealToPlayers(active_players)
	_set_current_player(role_manager.under_the_gun)
	
func _gather_blinds() -> void:
	role_manager.small_blind._bet_chips(current_blind)
	role_manager.big_blind._bet_chips(current_blind * 2)
	current_min_bet = current_blind * 2

func _is_player_bust(player: Player) -> bool:
	if player.chip_count < 0:
		return true
	return false

func _set_active_players() -> void:
	var players = get_node("../Players").get_children() as Array[Player]
	active_players.clear()
	for player in players:	
		if _is_player_bust(player) == true:
			player.is_in_game = false
			get_node("../Players").remove_child(player)
			continue
		else:
			player.is_in_round = true	
		active_players.append(player)

func _set_current_player(player: Player) -> void:
	current_player = player
	change_players_turn.emit(player, current_min_bet)
	
func _change_turns() -> void:
	if _check_if_betting_is_done() == true: _end_betting_round()
	current_player_index += 1
	if current_player_index > active_players.size() -1:
		current_player_index = 0
	_set_current_player(active_players[current_player_index])

func _check_if_betting_is_done() -> bool:
	return current_player == role_manager.under_the_gun and current_player.current_bet == current_min_bet
		

func _on_player_folded(player: Player) -> void:
	active_players.remove_at(active_players.find(player))
	_change_turns()
	
func _on_player_betted(new_min_bet: int):
	current_min_bet = new_min_bet
	_change_turns()

func _end_betting_round() -> void:
	current_min_bet = current_blind * 2
	_collect_chips()
	if active_players.size() > 1:
		_begin_next_betting_round()
	else:
		_end_round(active_players)
	
func _collect_chips() -> void:
	var collected_pot: int = 0
	for player in get_node("../Players").get_children() as Array[Player]:
		if player.has_node("ChipSpace/Chip") == true:
			var chip = player.get_node("ChipSpace/Chip") as Chip
			collected_pot += chip.amount
			player.current_bet = 0
			player.get_node("ChipSpace").remove_child(chip)
	center_of_table._add_to_pot(collected_pot)
		
func _begin_next_betting_round() -> void:
	if center_of_table.get_children().size() == 1:
		_start_flop()
	elif center_of_table.get_children().size() == 4:
		_start_turn()
	elif center_of_table.get_children().size() == 5:
		_start_river()
	elif center_of_table.get_children().size() == 6:
		_start_show_down()
		
	
func _start_flop() -> void:
	dealer._deal_to_table(3)

func _start_turn() -> void:
	dealer._deal_to_table(1)

func _start_river() -> void:
	dealer._deal_to_table(1)
	
func _start_show_down() -> void:
	var show_down_manager = ShowDownManager.new(_create_hands())
	_end_round(show_down_manager.winning_players)
	
	
func _end_round(winners: Array[Player]) -> void:
	_give_pot_to_winner(winners)
	_clear_table()
	current_blind = current_blind * 2
	current_min_bet = current_blind *2
	_set_active_players()
	role_manager._set_roles(active_players)
	dealer._regenerate_deck()
	_start_round()
	
	
func _create_hands() -> Array[Hand]:
	var hands: Array[Hand]
	for player in active_players:
		var hand = Hand.new(player, player.player_hand + center_of_table.community_cards)
		hands.append(hand)
	return hands
	
func _give_pot_to_winner(winners: Array[Player]) -> void:
	var pot = center_of_table.get_node("Chip") as Chip
	for winner in winners:
		winner._set_chip_count(winner.chip_count + (pot.amount / winners.size()))
	
func _clear_table() -> void:
	for player in active_players:
		player._add_place_holder_cards()
	role_manager._remove_dealer_chip()
	center_of_table._clear_table()

