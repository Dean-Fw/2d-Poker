class_name ShowDownManager

enum hand_rankings {high_card, pair, two_pair, three_of_a_kind, straight, flush, four_of_a_kind, full_house, straight_flush, royal_flush}
var _hands: Array[Hand]
var winning_players:  Array[Player]

var community_card_hand: int
var winning_hand: String

func _init(hands: Array[Hand], community_cards: Array[CardClass]):
	_hands = hands
	community_card_hand = _set_community_hand(Hand.new(hands[0].hand_owner, [],community_cards))
	_rank_hands(_hands)
	_set_winning_players()
	print(winning_hand)

func _set_community_hand(hand: Hand) -> int:
	_rank_hands([hand])
	return hand.hand_rank

func _rank_hands(hands: Array[Hand]):
	for hand in _hands: 
		if _is_pair(hand) == true and community_card_hand != hand_rankings.pair: hand._set_hand_rank(hand_rankings.pair)
		if _is_two_pair(hand) == true and community_card_hand != hand_rankings.two_pair: hand._set_hand_rank(hand_rankings.two_pair)
		if _is_three_of_a_kind(hand) == true and community_card_hand != hand_rankings.three_of_a_kind: hand._set_hand_rank(hand_rankings.three_of_a_kind)
		if _is_straight(hand) == true and community_card_hand != hand_rankings.straight: hand._set_hand_rank(hand_rankings.straight)
		if _is_flush(hand) == true and community_card_hand != hand_rankings.flush: hand._set_hand_rank(hand_rankings.flush)
		if _is_four_of_a_kind(hand) == true and community_card_hand != hand_rankings.four_of_a_kind: hand._set_hand_rank(hand_rankings.four_of_a_kind)
		if _is_full_house(hand) == true and community_card_hand != hand_rankings.full_house: hand._set_hand_rank(hand_rankings.full_house)
		if _is_straight_flush(hand) == true and community_card_hand != hand_rankings.straight_flush: hand._set_hand_rank(hand_rankings.straight_flush)
		if _is_royal_flush(hand) == true and community_card_hand != hand_rankings.royal_flush: hand._set_hand_rank(hand_rankings.royal_flush)

func _set_winning_players():
	var best_hand: int
	for hand in _hands:
		if winning_players.size() == 0:
			winning_players.append(hand.hand_owner)
			best_hand = hand.hand_rank
		elif hand.hand_rank > best_hand:
			winning_players.clear()
			winning_players.append(hand.hand_owner)
			best_hand = hand.hand_rank
		elif hand.hand_rank == best_hand:
			winning_players.append(hand.hand_owner)
	if best_hand == 0:
		_find_highest_card(_hands)
	winning_hand = hand_rankings.keys()[best_hand]

func _find_highest_card(hands: Array[Hand]) -> void:
	var best_card: int
	winning_players.clear()
	for hand in hands:
		for value in hand.player_cards_only_values:
			if value > best_card:
				winning_players.clear()
				best_card = value
				winning_players.append(hand.hand_owner)
			elif value == best_card:
				winning_players.append(hand.hand_owner)

func _find_num_pairs(hand: Hand) -> int:
	var num_of_pairs: int
	
	for value_count in hand.hand_value_hist:
		if value_count == 2:
			num_of_pairs += 1
	return num_of_pairs

func _is_straight(hand: Hand) -> bool:
	var curernt_run: int = 1
	var best_run: int
	
	for value_count_index in range(hand.hand_value_hist.size() -1):
		if (value_count_index + 1 > hand.hand_value_hist.size() - 1) and (hand.hand_value_hist[value_count_index] != 0 and hand.hand_value_hist[0] != 0):
			curernt_run += 1
		elif hand.hand_value_hist[value_count_index] != 0 and hand.hand_value_hist[value_count_index + 1] != 0:
			curernt_run += 1
		else:
			if best_run < curernt_run:
				best_run = curernt_run
			curernt_run = 1
	if best_run < curernt_run:
			best_run = curernt_run
	return best_run >= 5

func _is_flush(hand: Hand) -> bool:
	for suit_count in hand.hand_suit_hist:
		if suit_count >= 5:
			return true
	return false

func _is_pair(hand: Hand) -> bool:
	if _find_num_pairs(hand) == 1:
		return true
	return false

func _is_two_pair(hand: Hand) -> bool:
	if _find_num_pairs(hand) == 2:
		return true
	return false

func _is_three_of_a_kind(hand: Hand) -> bool:
	for value_count in hand.hand_value_hist:
		if value_count == 3:
			return true
	return false

func _is_four_of_a_kind(hand: Hand) -> bool:
	for value_count in hand.hand_value_hist:
		if value_count == 4:
			return true
	return false

func _is_full_house(hand: Hand) -> bool:
	return _is_three_of_a_kind(hand) == true and _is_pair(hand) == true

func _is_straight_flush(hand: Hand) -> bool:
	return _is_straight(hand) == true and _is_flush(hand) == true

func _is_royal_flush(hand: Hand) -> bool:
	var curernt_run: int = 1
	for value_count_index in range(9,12): 
		if (value_count_index + 1 > hand.hand_value_hist.size() - 1) and (hand.hand_value_hist[value_count_index] != 0 and hand.hand_value_hist[0] != 0):
			curernt_run += 1
		elif hand.hand_value_hist[value_count_index] != 0 and hand.hand_value_hist[value_count_index + 1] != 0:
			curernt_run += 1
		else:
			curernt_run = 1
	return curernt_run >= 5 and _is_flush(hand)
