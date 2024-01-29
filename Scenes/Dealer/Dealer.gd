extends TextureRect

var deck = preload("res://Scenes/Deck/Deck.tscn")
var player 
var deck_inst
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	deck_inst = deck.instantiate()
	add_child(deck_inst)

func _input(event):
	if event.is_action_pressed("spawn"):
		_dealToPlayer()	

func _pick_up_card():
	# Takes a random card from the deck and removes it
	var cards: Array = deck_inst.get_children()
	var selected_card: CardClass = cards.pick_random()
	deck_inst.remove_child(selected_card)
	return selected_card
	
func _dealCard() -> CardClass:
	var card_to_deal: CardClass = _pick_up_card()
	card_to_deal._turn_card()
	return card_to_deal

func _dealToPlayer():
	var card_slots: Array[CardClass] = [player.get_node("Cards/Card1"),player.get_node("Cards/Card2")]
	for card_slot in card_slots:
		print(player.get_node("Cards/Card1").value)
		var card_dealt = _dealCard()
		card_slot.texture = card_dealt.texture
		card_slot.suit = card_dealt.suit
		card_slot.value = card_dealt.value
