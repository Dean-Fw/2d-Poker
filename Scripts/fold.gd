extends Button

const placeholder_texture = preload("res://Scenes/Card/CardImages/Placeholder.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed(self._fold)

func _fold():
	var cards: Array[CardClass] = [get_node("../../Cards/Card1"), get_node("../../Cards/Card2")]
	for card in cards:
		card.texture = placeholder_texture
		card.value = 0
		card.suit = ""
	
