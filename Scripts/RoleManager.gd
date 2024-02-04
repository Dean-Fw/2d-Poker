class_name RoleManager

const dealer_chip_scene = preload("res://Scenes/Chip/DealerChip.tscn") as PackedScene
var dealer_chip = dealer_chip_scene.instantiate()

var dealer: Player
var small_blind: Player
var big_blind: Player
var under_the_gun: Player

func _init(active_players: Array[Player]):
	_set_roles(active_players)
	
func _set_roles(active_players: Array[Player]) -> void:
	if active_players.size() > 2:
		dealer = _set_dealer(active_players)
		_give_dealer_chip()
	small_blind = _set_small_blind(active_players)
	big_blind = _set_big_blind(active_players)
	under_the_gun = _set_under_the_gun(active_players)
	
func _set_dealer(active_players: Array[Player]) -> Player:
	if dealer == null:
		return active_players[0]
	else :
		return _set_role(dealer, active_players)

func _set_small_blind(active_players: Array[Player]) -> Player:
	if small_blind == null:
		if dealer == null:
			return active_players[0]
		else:
			return active_players[1]
	else:
		return _set_role(small_blind, active_players)
		
func _set_big_blind(active_players: Array[Player]) -> Player:
	if big_blind == null:
		if dealer == null:
			return active_players[1]
		else:
			return active_players[2]
	else:
		return _set_role(big_blind, active_players)

func _set_under_the_gun(active_players: Array[Player]) -> Player:
	if active_players.find(big_blind) + 1 <= active_players.size() - 1:
		return active_players[active_players.find(big_blind) + 1]
	else:
		return active_players[0]

func _set_role(role: Player, active_players: Array[Player]) -> Player:
	if active_players.find(role) + 1 > active_players.size() - 1:
		return active_players[0]
	else:
		return active_players[active_players.find(role) + 1]

func _give_dealer_chip() -> void:
	dealer.get_node("ChipSpace").add_child(dealer_chip)

func _remove_dealer_chip() -> void:
	dealer.get_node("ChipSpace").remove_child(dealer_chip)
