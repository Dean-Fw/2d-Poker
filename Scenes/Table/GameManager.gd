class_name GameManager

extends Control

signal change_players_turn

var active_players: Array[Player]
var current_player: Player
var current_player_index: int = 0
var current_blind: int = 5
var current_min_bet: int

var role_manager: RoleManager

func _ready():
	_set_active_players()
	role_manager = RoleManager.new(active_players)
	_start_round()

func _start_round() -> void:
	_set_roles()
	_gather_blinds()

func _set_roles() -> void:
	if active_players.size() > 2:
		role_manager._set_dealer()
	role_manager._set_small_blind()
	role_manager._set_big_blind()
	role_manager._set_under_the_gun()
	_set_current_player(role_manager.under_the_gun)

func _gather_blinds() -> void:
	role_manager.small_blind._bet_chips(current_blind)
	role_manager.big_blind._bet_chips(current_blind * 2)
	current_min_bet = current_blind * 2

func _set_active_players() -> void:
	var players = get_node("../Players").get_children() as Array[Player]
	for player in players:
		if player.is_in_game and player.is_in_round:
			active_players.append(player)

func _set_current_player(player: Player) -> void:
	current_player = player
	change_players_turn.emit(player)

func _change_turns() -> void:
	current_player_index += 1
	if current_player_index > active_players.size() -1:
		current_player_index = 0
	_set_current_player(active_players[current_player_index])

func _on_player_folded(player: Player) -> void:
	active_players.remove_at(active_players.find(player))
	_change_turns()

func _on_human_player_folded(player: Player) -> void:
	_on_player_folded(player)

