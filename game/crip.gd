tool
extends PathFollow2D

export var speed = 30

const RECT_BODIES = [Rect2(0, 0, 2, 4)]
const RECT_PANTS = [Rect2(3, 0, 2, 10)]
const RECT_ARMOR = [Rect2(6, 0, 12, 10)]
const RECT_HAIRS = [Rect2(19, 0, 8, 8), Rect2(19, 8, 4, 4)]
const RECT_HATS = [Rect2(28, 0, 4, 9)]
const RECT_SHIELDS = [Rect2(33, 0, 8, 9)]
const RECT_WEAPONS = [Rect2(42,0, 10, 10), Rect2(52, 0, 2, 5)]

export var body_idx = 0 setget set_body_idx
export var pants_idx = 0 setget set_pants_idx
export var armor_idx = 0 setget set_armor_idx
export var hairs_idx = 0 setget set_hairs_idx
export var hat_idx = 0 setget set_hat_idx
export var shield_idx = 0 setget set_shield_idx
export var weapon_idx = 0 setget set_weapon_idx


func _ready():
	set_process(true)
func set_body_idx(idx):
	body_idx = idx
	if has_node("sprites/body"):
		set_idx(get_node("sprites/body"), RECT_BODIES, idx)
func set_pants_idx(idx):
	pants_idx = idx
	if has_node("sprites/pants"):
		set_idx(get_node("sprites/pants"), RECT_PANTS, idx)
func set_armor_idx(idx):
	armor_idx = idx
	if has_node("sprites/armor"):
		set_idx(get_node("sprites/armor"), RECT_ARMOR, idx)
func set_hairs_idx(idx):
	hairs_idx = idx
	if has_node("sprites/hairs"):
		set_idx(get_node("sprites/hairs"), RECT_HAIRS, idx)
func set_hat_idx(idx):
	hat_idx = idx
	if has_node("sprites/hat"):
		set_idx(get_node("sprites/hat"), RECT_HATS, idx)
func set_shield_idx(idx):
	shield_idx = idx
	if has_node("sprites/shield"):
		set_idx(get_node("sprites/shield"), RECT_SHIELDS, idx)
func set_weapon_idx(idx):
	weapon_idx = idx
	if has_node("sprites/weapon"):
		set_idx(get_node("sprites/weapon"), RECT_WEAPONS, idx)	
	
func set_idx(node, rects, idx):
	if idx < 0:
		node.hide()
		return
	node.show()
	var frame_x = 0
	var frame_y = 0
	for rect in rects:
		if frame_x || frame_y:
			break
		if idx > rect.size.x*rect.size.y:
			idx -= rect.size.x*rect.size.y
		else:
			frame_x = rect.pos.x
			frame_y = rect.pos.y
			for y in range(rect.size.y):
				if idx == -1:
					break
				for x in range(rect.size.x):
					if idx > 0:
						idx -= 1
					else:
						frame_x += x
						frame_y += y
						idx = -1
						break
		print("Frame: ", frame_x, ", ", frame_y)
		var frame = frame_y * node.get_hframes() + frame_x
		node.set_frame(frame)
					
			  
	
	
func _process(delta):
	set_offset(get_offset()+speed*delta)
	if get_unit_offset() >= 1:
		get_parent().queue_free()

