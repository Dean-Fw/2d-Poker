class_name CardClass

extends Node2D

var value: int 
var suit: String 

const card_back = preload("res://Scenes/Card/CardImages/backOfCard.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = card_back

func _turn_card():
	# Take suit and value and assign a texture
	var card_texture = load("res://Scenes/Card/CardImages/"+ _change_value_to_name(value) + "_of_" + suit + ".png")
	self.texture = card_texture

func _change_value_to_name(value):
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
