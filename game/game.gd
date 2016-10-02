
extends Node

func _ready():
	randomize()
	
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


