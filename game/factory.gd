
extends Node2D

const MainPath = preload("path.tscn")
const Creep = preload("creep.tscn")
export (int, "Top", "Bottom") var team = 0
export var crip_delay = 1.0
export var wave_size = 4.0
export var wave_delay = 10.0




func _ready():
	while true:
		for i in range(wave_size):
			yield(game.wait(crip_delay), "timeout")
			spawn_creep()
		yield(game.wait(wave_delay), "timeout")
		
	
	
func spawn_creep():
	print("Spawn crip")
	var path = MainPath.instance()
	var creep = Creep.instance()
	creep.team = team
	get_parent().add_child(path)
	path.add_child(creep)
