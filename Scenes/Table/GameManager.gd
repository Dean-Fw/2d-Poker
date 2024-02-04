class_name GameManager

extends Control

signal change_players_turn(current_player: Player, current_min_bet: int)

const chip_scene = preload("res://Scenes/Chip/Chip.tscn")

var active_players: Array[Player]
var current_player: Player
var current_player_index: int = 0
var current_blind: int = 5
var current_min_bet: int

var role_manager: RoleManager
var show_down_manager: ShowDownManager
var dealer: Dealer

var center_of_table: HBoxContainer

func _ready():
	center_of_table = get_node("../CenterOfTable")
	dealer = get_node("../Dealer") as Dealer
	_set_active_players()
	role_manager = RoleManager.new(active_players)
	_start_round()
	

func _start_round() -> void:
	_set_roles()
	_gather_blinds()
	dealer._dealToPlayers(active_players)
	_set_current_player(role_manager.under_the_gun)
	
func _set_roles() -> void:
	if active_players.size() > 2:
		role_manager._set_dealer()
	role_manager._set_small_blind()
	role_manager._set_big_blind()
	role_manager._set_under_the_gun()


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
	if current_player == role_manager.under_the_gun and current_player.current_bet == current_min_bet:
		current_min_bet = current_blind * 2
		_end_betting_round()
	change_players_turn.emit(player, current_min_bet)

func _change_turns() -> void:
	if active_players.size() == 1:
		_end_betting_round()
		return
	current_player_index += 1
	if current_player_index > active_players.size() -1:
		current_player_index = 0
	_set_current_player(active_players[current_player_index])

func _on_player_folded(player: Player) -> void:
	active_players.remove_at(active_players.find(player))
	_change_turns()
	
func _on_player_betted(new_min_bet: int):
	current_min_bet = new_min_bet
	_change_turns()

func _end_betting_round() -> void:
	_collect_chips()
	if active_players.size() > 1:
		_begin_next_betting_round()
	else:
		_end_round(active_players[0])
	
func _collect_chips() -> void:
	var collected_pot: int = 0
	for player in get_node("../Players").get_children() as Array[Player]:
		if player.has_node("ChipSpace/Chip") == true:
			var chip = player.get_node("ChipSpace/Chip") as Chip
			collected_pot += chip.amount
			player.current_bet = 0
			player.get_node("ChipSpace").remove_child(chip)
	_add_to_pot(collected_pot)
	
func _add_to_pot(collected_pot: int) -> void:
	if center_of_table.has_node("Chip") == false:
		var pot_instance = chip_scene.instantiate()._set_value(collected_pot)
		center_of_table.add_child(pot_instance)
	else:
		var pot = center_of_table.get_node("Chip") as Chip
		pot._set_value(pot.amount + collected_pot)
	
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
	show_down_manager = ShowDownManager.new()
	
func _end_round(winner: Player) -> void:
	_give_pot_to_winner(winner)
	_clear_table(winner)
	current_blind = current_blind * 2
	_set_active_players()
	_start_round()
	
	
func _give_pot_to_winner(winner: Player) -> void:
	var pot = center_of_table.get_node("Chip") as Chip
	winner._set_chip_count(winner.chip_count + pot.amount)
	center_of_table.remove_child(pot)
	
func _clear_table(winner: Player) -> void:
	winner._add_place_holder_cards()
	var dealer_chip = role_manager.dealer.get_node("ChipSpace/DealerChip")
	role_manager.dealer.get_node("ChipSpace").remove_child(dealer_chip)
	for card in center_of_table.get_children():
		center_of_table.remove_child(card)

