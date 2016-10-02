extends TouchScreenButton

var radius = 50.0
var effects = []

func set_card(card):
	effects.append(card.get_effects())
	return self
	


func _on_TouchScreenButton_pressed():
	print(effects)
