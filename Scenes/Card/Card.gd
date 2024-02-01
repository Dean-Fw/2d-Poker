class_name CardClass

extends TextureRect

@export var value: int
@export var suit: String

const card_back = preload("res://Assets/CardImages/backOfCard.png")

func _turn_card() -> void:
	# Take suit and value and assign a texture
	var card_texture = load("res://Assets/CardImages/"+ _change_value_to_name() + "_of_" + suit + ".png")
	self.texture = card_texture

func _set_suit(given_suit: String) -> CardClass:
	suit = given_suit
	return self

func _set_value(given_value: int) -> CardClass:
	value = given_value
	return self

func _set_texture():
	self.texture = card_back
	return self

func _change_value_to_name() -> String:
	if value == 11:
		return "jack"
	elif value == 12:
		return "queen"
	elif value == 13:
		return "king"
	elif value == 1:
		return "ace"
	else:
		return str(value)
