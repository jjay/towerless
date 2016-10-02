extends TouchScreenButton

var radius = 50.0
var cards = []

func set_card(card):
	cards.append(card)
	return self