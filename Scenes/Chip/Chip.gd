class_name Chip

extends HBoxContainer

@export var amount: int = 0

var amount_label

func _set_value(set_amount: int) -> Chip:
	amount = set_amount
	get_node("ChipValue").text = str(amount)
	return self





