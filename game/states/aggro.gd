
extends "base.gd"
const MoveState = preload("move.gd")
var target
var next_damage = 0

func enter(p_creep):
	creep = p_creep
	target.connect("die", creep, "change_state", [MoveState])
func process(delta):
	if !target:
		target = nearest_aggro()
	if !target:
		creep.change_state(MoveState)
		return
	next_damage = max(0, next_damage - delta)
	var dir = target.find_attacker_position(creep)
	if dir.length() > creep.body_radius*0.5:
		var tr = dir.normalized()*creep.speed * delta
		creep.set_h_offset(creep.get_h_offset() + tr.x)
		creep.set_v_offset(creep.get_v_offset() + tr.y)
	elif !next_damage:
		var anim_name = "attack_left"
		if target.get_global_pos().x > creep.get_global_pos().x:
			anim_name = "attack_right"
		var animator = creep.get_node("animator")
		var duration = animator.get_animation(anim_name).get_length()
		animator.set_speed(duration/creep.attack_delay)
		creep.get_node("animator").play(anim_name)
		game.wait(0.7).connect("timeout", target, "take_damage", [creep.damage])
		next_damage =	creep.attack_delay