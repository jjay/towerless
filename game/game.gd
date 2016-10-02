
extends Node

func _ready():
	randomize()
	
var selected_card = null setget set_selected_card

func set_selected_card(newcard):
	if selected_card != null:
		selected_card.deselect()

	if newcard == null:
		return

	selected_card = newcard
	selected_card.select()


func wait(time):
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", timer, "queue_free")
	timer.set_one_shot(true)
	timer.set_wait_time(time)
	timer.start()
	return timer
	
func pick_random(list):
	return list[int(list.size()*randf())]
