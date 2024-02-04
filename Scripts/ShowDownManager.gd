class_name ShowDownManager

extends  Control

## suit index - value key: 0 - hearts, 1 - spades, 2 - diamonds, 3 - clubs
enum suits {hearts, spades, diamonds, clubs}
enum hist_type {value, suit}

##TEMP
const dealer_scene = preload("res://Scenes/Dealer/Dealer.tscn")
var Hand: Array[CardClass]

func _ready():
	var dealer_inst = dealer_scene.instantiate() as Dealer
	add_child(dealer_inst)
	for card in range(7):
		var dealt_card = dealer_inst._pick_up_card()
		Hand.append(dealt_card)
		print("Value: " + str(dealt_card.value) + " Suit: " + str(dealt_card.suit))
	print("-----------------")
	print("is pair: " + str(_is_pair()))
	print("is two pair: " + str(_is_two_pair()))
	print("is three of a kind: " + str(_is_three_of_a_kind()))
	print("is straight: " + str(_is_straight()))
	print("is flush: " + str(_is_flush()))
	print("is four of a kind: " + str(_is_four_of_a_kind()))
	print("is full house: " + str(_is_full_house()))
	print("is straight flush: " + str(_is_straight_flush()))
	print("is royal flush: " + str(_is_royal_flush()))
	
	
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

func _create_fake_suit_hist() -> Array[int]: ## FOR TESTING PURPOSES
	var hist = _create_empty_histogram(hist_type.suit)
	var fake_hand: Array[String] = ["spades", "spades", "spades", "spades", "diamonds", "spades"]
	for suit in fake_hand:
		if suit == "hearts":
			hist[suits.hearts] += 1
		elif suit == "spades":
			hist[suits.spades] += 1
		elif suit == "diamonds":
			hist[suits.diamonds] += 1
		elif suit == "clubs":
			hist[suits.clubs] += 1
	return hist

func _create_value_hist(hand: Array[CardClass]) -> Array[int]:
	var hist = _create_empty_histogram(hist_type.value)
	
	for card in hand:
		hist[card.value - 1] += 1
	return hist

func _create_fake_value_hist() -> Array[int]: ## FOR TESTING PURPOSES
	var hist = _create_empty_histogram(hist_type.value)
	var fake_hand = [1,9,11,12,13,7,8]
	for value in fake_hand:
		hist[value-1] += 1
	return hist

func _find_num_pairs() -> int:
	var value_hist: Array[int] = _create_value_hist(Hand)
	var num_of_pairs: int
	
	for value_count in value_hist:
		if value_count == 2:
			num_of_pairs += 1
	return num_of_pairs

func _is_pair() -> bool:
	if _find_num_pairs() == 1:
		return true
	return false

func _is_two_pair() -> bool:
	if _find_num_pairs() == 2:
		return true
	return false

func _is_three_of_a_kind() -> bool:
	var value_hist: Array[int] = _create_value_hist(Hand)
	
	for value_count in value_hist:
		if value_count == 3:
			return true
	return false

func _is_straight() -> bool:
	var value_hist: Array[int] = _create_value_hist(Hand)
	var curernt_run: int = 1
	var best_run: int
	for value_count_index in range(value_hist.size()):
		if (value_count_index + 1 > value_hist.size() - 1) and (value_hist[value_count_index] != 0 and value_hist[0] != 0):
			curernt_run += 1
		elif value_hist[value_count_index] != 0 and value_hist[value_count_index + 1] != 0:
			curernt_run += 1
		else:
			if best_run < curernt_run:
				best_run = curernt_run
			curernt_run = 1
	if best_run < curernt_run:
			best_run = curernt_run
	return best_run >= 5

func _is_flush() -> bool:
	var suit_hist = _create_suit_hist(Hand)

	for suit_count in suit_hist:
		if suit_count >= 4:
			return true
	return false

func _is_four_of_a_kind() -> bool:
	var value_hist = _create_value_hist(Hand)
	
	for value_count in value_hist:
		if value_count == 4:
			return true
	return false

func _is_full_house() -> bool:
	return _is_three_of_a_kind() and _is_pair()

func _is_straight_flush() -> bool:
	return _is_straight() and _is_flush()

func _is_royal_flush() -> bool:
	var value_hist = _create_value_hist(Hand)
	var curernt_run: int = 1
	for value_count_index in range(9,13):
		if (value_count_index + 1 > value_hist.size() - 1) and (value_hist[value_count_index] != 0 and value_hist[0] != 0):
			curernt_run += 1
		elif value_hist[value_count_index] != 0 and value_hist[value_count_index + 1] != 0:
			curernt_run += 1
		else:
			curernt_run = 1
	return curernt_run >= 5 and _is_flush()

