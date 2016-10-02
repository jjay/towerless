
extends TouchScreenButton

const Tower = preload('Tower.tscn')

var tower = null

func _ready():
	connect("released", self, "released")


func released():
	var card = game.selected_card
	if card == null:
		return 
	
	card.use()
	
	if tower == null:
		tower = Tower.instance()
		add_child(tower)
		tower.set_owner(self)
		
	tower.set_card(card)

