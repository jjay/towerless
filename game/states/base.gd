
extends Reference
var creep = null
func enter(p_creep):
	creep = p_creep
func process(delta):
	return
func exit():
	return
	
func nearest_aggro():
	if !creep:
		return
	var dist = 100000
	var nearest = null
	for node in creep.in_aggro_range:
		var d = node.get_global_pos().distance_to(creep.get_global_pos())
		if d < dist:
			dist = d
			nearest = node
	return nearest
	
func want_aggro(other):
	pass


