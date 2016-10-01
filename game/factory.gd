
extends Node2D

const MainPath = preload("path.tscn")
const Crip = preload("crip.tscn")
export var crip_delay = 1.0
export var wave_size = 4.0
export var wave_delay = 10.0



func _ready():
	while true:
		for i in range(wave_size):
			yield(game.wait(crip_delay), "timeout")
			spawn_crip()
		yield(game.wait(wave_delay), "timeout")
		
	
	
func spawn_crip():
	var path = MainPath.instance()
	var crip = Crip.instance()
	get_parent().add_child(path)
	path.add_child(crip)


