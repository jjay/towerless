extends HBoxContainer

const CardScene = preload("Card.tscn")

var cards = [
	CardScene.instance().set_card_type(Card.HEALTH),
	CardScene.instance().set_card_type(Card.ATTACK),
	CardScene.instance().set_card_type(Card.DEFENCE),
	CardScene.instance().set_card_type(Card.SPEED),
]

func _ready():
	pass
	#for card in cards:
	#	add_child(card)
	#	card.set_owner(self)
	