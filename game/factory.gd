
extends Node2D

const MainPath = preload("path.tscn")
const Creep = preload("creep.tscn")
export (int, "Top", "Bottom") var team = 0
export var crip_delay = 1.0
export var wave_size = 4.0
export var wave_delay = 10.0

var curves = {}




func _ready():
	var template = preload("path_templates.tscn").instance()
	var keys = ["left", "right", "center"]
	for key in keys:
		curves[key] = []
		for path2d in template.get_node(key).get_children():
			curves[key].append(path2d.get_curve())
	while true:
		keys.sort_custom(self, "randsort")
		for key in keys:
			var group = curves[key]
			for i in range(wave_size):
				game.wait(0.1 + i*crip_delay).connect("timeout", self, "spawn_creep", [game.pick_random(group)])
			yield(game.wait(0.5 + randf()), "timeout")
		yield(game.wait(wave_delay), "timeout")
		
func rand_sort(a,b):
	return randf() >= 0.5
	
	
func spawn_creep(curve):
	print("Spawn crip")
	var path = MainPath.instance()
	path.set_curve(curve)
	var creep = Creep.instance()
	creep.team = team
	get_parent().add_child(path)
	path.add_child(creep)


