extends HBoxContainer

const CardScene = preload("Card.tscn")

var selected_card = null
const CARDS = ['Control1', 'Control2', 'Control3', 'Control4']

func card_selected(card):
	var position = card.get_pos() + Vector2(0, -15)
	card.set_pos(position)

func card_deselected(card):
	var position = card.get_pos() + Vector2(0, 15)
	card.set_pos(position)

func _ready():
	for control_name in CARDS:
		get_node(control_name).connect('selected', self, "card_selected")
		get_node(control_name).connect('deselected', self, "card_deselected")
	