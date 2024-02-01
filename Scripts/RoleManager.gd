class_name RoleManager

const dealer_chip_scene = preload("res://Scenes/Chip/DealerChip.tscn") as PackedScene

var dealer: Player
var small_blind: Player
var big_blind: Player
var under_the_gun: Player

var _active_players: Array[Player]

func _init(active_players: Array[Player]):
	_active_players = active_players
	
func _set_dealer() -> void:
	if dealer == null:
		dealer = _active_players[0]
	else :
		_set_role(dealer)
	_give_dealer_chip()

func _set_small_blind() -> void:
	if small_blind == null:
		if dealer == null:
			small_blind = _active_players[0]
		else:
			small_blind = _active_players[1]
	else:
		_set_role(small_blind)
		
func _set_big_blind() -> void:
	if big_blind == null:
		if dealer == null:
			big_blind = _active_players[1]
		else:
			big_blind = _active_players[2]
	else:
		_set_role(big_blind)

func _set_under_the_gun() -> void:
	if _active_players.find(big_blind) + 1 < _active_players.size() - 1:
		under_the_gun = _active_players[_active_players.find(big_blind) + 1]
	else:
		under_the_gun = _active_players[0]

func _set_role(role: Player) -> void:
	if _active_players.find(role) + 1 > _active_players.size() - 1:
		role = _active_players[0]
	else:
		role = _active_players[_active_players.find(role) + 1]

func _give_dealer_chip() -> void:
	print("hello")
	dealer.get_node("ChipSpace").add_child(dealer_chip_scene.instantiate())
	
