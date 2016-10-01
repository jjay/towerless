tool
extends Path2D

const POINT_SCATTER = 10

func _ready():
	var old_curve = get_curve()
	if !old_curve:
		return
		
	var curve = Curve2D.new()
	set_curve(curve)
		
	for idx in range(old_curve.get_point_count()):
		var curr = old_curve.get_point_pos(idx)
		if idx > 0 && idx < old_curve.get_point_count() - 1:
			curr += Vector2(rand_range(-POINT_SCATTER,POINT_SCATTER), rand_range(-POINT_SCATTER,POINT_SCATTER))
		curve.add_point(curr)
	
	for idx in range(curve.get_point_count()):
		if idx == 0:
			continue
		if idx == curve.get_point_count()-1:
			continue
		var prev = curve.get_point_pos(idx-1)
		var curr = curve.get_point_pos(idx)
		var next = curve.get_point_pos(idx+1)
		var a1 = (prev - curr).angle()
		var a2 = (curr - next).angle()
		var angle = (a1 + a2)*0.5
		if abs(angle-a1) > PI*0.5:
			angle += PI
		angle += PI*0.5
		var out_vec = Vector2(curr.distance_to(next)*0.3,0)
		var in_vec = Vector2(curr.distance_to(prev)*0.3,0)
		curve.set_point_out(idx, out_vec.rotated(angle))
		curve.set_point_in(idx, out_vec.rotated(angle+PI))


