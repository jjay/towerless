
extends "base.gd"
const AggroState = preload("aggro.gd")

func enter(p_creep):
	.enter(p_creep)
	var animator = creep.get_node("animator")
	animator.play("walk")
	animator.set_speed(1)
func process(delta):
	if !creep:
		return
	var aggro = nearest_aggro()
	if aggro:
		creep.change_state(AggroState)
		creep.state.target = aggro
		return
	if creep.get_h_offset() || creep.get_v_offset():
		var offset = Vector2(creep.get_h_offset(), creep.get_v_offset())
		var tr = offset.normalized()*delta
		if tr.length() > offset.length():
			tr = offset
		creep.set_h_offset(creep.get_h_offset() - tr.x)
		creep.set_v_offset(creep.get_v_offset() - tr.y)
		
	#	return
	if creep.team == creep.TEAM_BOT:
		creep.set_offset(creep.get_offset()-creep.speed*delta)
		if creep.get_unit_offset() <= 0:
			creep.get_parent().queue_free()
	else:
		creep.set_offset(creep.get_offset()+creep.speed*delta)
		if creep.get_unit_offset() >= 1:
			creep.get_parent().queue_free()