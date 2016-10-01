tool
extends PathFollow2D

signal die

const AggroState = preload("states/aggro.gd")
const MoveState = preload("states/move.gd")

const STATE_WALK = 0
const STATE_ATTACK = 1

const TEAM_TOP = 0
const TEAM_BOT = 1


const RECT_BODIES = [Rect2(0, 0, 2, 4)]
const RECT_PANTS = [Rect2(3, 0, 2, 10)]
const RECT_ARMOR = [Rect2(6, 0, 12, 10)]
const RECT_HAIRS = [Rect2(19, 0, 8, 8), Rect2(19, 8, 4, 4)]
const RECT_HATS = [Rect2(28, 0, 4, 9)]
const RECT_SHIELDS = [Rect2(33, 0, 8, 9)]
const RECT_WEAPONS = [Rect2(42,0, 10, 10), Rect2(52, 0, 2, 5)]

export (int, "Top", "Bot") var team = TEAM_TOP
export var speed = 30
export var damage = 10
export var health = 100
export var attack_delay = 1.5
export var body_radius = 30.0 setget set_body_radius
export var aggro_radius = 30.0 setget set_aggro_radius
export var body_idx = 0 setget set_body_idx
export var pants_idx = 0 setget set_pants_idx
export var armor_idx = 0 setget set_armor_idx
export var hairs_idx = 0 setget set_hairs_idx
export var hat_idx = 0 setget set_hat_idx
export var shield_idx = 0 setget set_shield_idx
export var weapon_idx = 0 setget set_weapon_idx

onready var aggro = get_node("aggro")
onready var body = get_node("body")

var in_aggro_range = {}
var attacker_positions = {}
var state = null

func _ready():
	if !get_tree().is_editor_hint():
		if team == TEAM_BOT:
			set_unit_offset(0.999)
			get_node("tile").set_color(Color("62eb0000"))
			for area in [aggro, body]:
				area.set_collision_mask(area.get_collision_mask() >> 2)
				area.set_layer_mask(area.get_layer_mask() << 2)
		set_process(true)
		aggro.connect("area_enter", self, "on_area_enter")
		aggro.connect("area_exit", self, "on_area_exit")
		
	
		change_state(MoveState)
		
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
		var frame = frame_y * node.get_hframes() + frame_x
		node.set_frame(frame)
func set_aggro_radius(radius):
	aggro_radius = radius
	if has_node("aggro/shape"):
		get_node("aggro/shape").get_shape().set_radius(radius)
func set_body_radius(radius):
	body_radius = radius
	if has_node("body/shape"):
		get_node("body/shape").get_shape().set_radius(radius)
			  
	
	
func _process(delta):
	if state:
		state.process(delta)
func change_state(state_class):
	if state != null:
		state.exit()
	state = state_class.new()
	state.call_deferred("enter", self)
	print("Entering ", state_class.get_path(), " state")
func on_area_enter(body):
	in_aggro_range[body.get_parent()]=true
func on_area_exit(body):
	if in_aggro_range.has(body.get_parent()):
		in_aggro_range.erase(body.get_parent())
func take_damage(amount):
	health -= amount
	if health <= 0:
		emit_signal("die")
		get_parent().queue_free()

func find_attacker_position(attacker):
	var delta = get_global_pos() - attacker.get_global_pos()
	if attacker_positions.has(attacker):
		return delta + attacker_positions[attacker]
	if attacker.attacker_positions.has(self):
		return delta - attacker.attacker_positions[self]
	for pos in [Vector2(body_radius, 0), Vector2(0, body_radius), Vector2(-body_radius, 0), Vector2(0, -body_radius)]:
		var good_position = true
		for c_attacker in attacker_positions:
			if attacker_positions[c_attacker] == pos:
				good_position = false
		if good_position:
			attacker_positions[attacker] = pos
			return pos + delta