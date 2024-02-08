class_name Hand


enum suits {hearts, spades, diamonds, clubs}
enum hist_type {value, suit}

var hand_owner: Player
@export var hand_value_hist: Array[int]
@export var hand_suit_hist: Array[int]
@export var hand_rank: int
@export var player_cards_only_values: Array[int]


func _init(player: Player, player_cards: Array[CardClass], table_cards: Array[CardClass]):
	hand_owner = player
	player_cards_only_values = _set_highest_player_card(player_cards)
	hand_value_hist = _create_value_hist(player_cards + table_cards)
	hand_suit_hist = _create_suit_hist(player_cards + table_cards)
	
func _set_hand_rank(new_hand_rank: int) -> void:
	if new_hand_rank > hand_rank:
		hand_rank = new_hand_rank
	
func _set_highest_player_card(player_cards: Array[CardClass]) -> Array[int]:
	var values: Array[int]
	for card in player_cards:
		values.append(card.value)
	return values
		

func _create_empty_histogram(type: int) -> Array[int]:
	var hist: Array[int] = [] 
	if type == hist_type.value:
		hist.resize(13)
	elif type == hist_type.suit:
		hist.resize(4)
	hist.fill(0)
	return hist

func _create_suit_hist(hand: Array[CardClass]) -> Array[int]:
	var hist = _create_empty_histogram(hist_type.suit)
	
	for card in hand:
		if card.suit.to_lower() == "hearts":
			hist[suits.hearts] += 1
		elif card.suit.to_lower() == "spades":
			hist[suits.spades] += 1
		elif card.suit.to_lower() == "diamonds":
			hist[suits.diamonds] += 1
		elif  card.suit.to_lower() == "clubs":
			hist[suits.clubs] += 1
	return hist

func _create_value_hist(hand: Array[CardClass]) -> Array[int]:
	var hist = _create_empty_histogram(hist_type.value)
	
	for card in hand:
		hist[card.value - 1] += 1
	return hist
