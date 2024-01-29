class_name CardClass

extends TextureRect

var value: int
var suit: String

func _turn_card():
	# Take suit and value and assign a texture
	var card_texture = load("res://Scenes/Card/CardImages/"+ _change_value_to_name() + "_of_" + suit + ".png")
	self.texture = card_texture

func _change_value_to_name():
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
