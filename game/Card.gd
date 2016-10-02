tool

extends TouchScreenButton

const grayscaleMaterialShader = preload('shaders/GrayscaleMaterialShader.tres')

const HEALTH = 'health'
const ATTACK = 'attack'
const DEFENCE = 'defence'
const SPEED = 'speed'
const FIREBALL = 'fireball'
const types = [HEALTH, ATTACK, DEFENCE, SPEED]
var cooldown = 30
var level = 1
var current_animation = null
export(String, "health", "attack", "defence", "speed", 'fireball') var card_type = HEALTH setget set_card_type
export var enabled = true setget set_enabled

signal selected(card)
signal deselected(card)
signal appeared(card)
signal disappeared(card)


var textures = {
	HEALTH: load('res://assets/health.png'),
	ATTACK: load('res://assets/sword.png'),
	DEFENCE: load('res://assets/protect.png'),
	SPEED: load('res://assets/wind.png'),
	FIREBALL: load('res://assets/wind.png'),
}

func get_effects():
	var effects = {}
	effects[HEALTH] = 0
	effects[DEFENCE] = 0
	effects[SPEED] = 0
	effects[ATTACK] = 0
	if card_type == HEALTH:
		effects[HEALTH] += 10 * level
	if card_type == DEFENCE:
		effects[DEFENCE] += 10 * level
	if card_type == SPEED:
		effects[SPEED] += 10 * level
	if card_type == ATTACK:
		effects[ATTACK] += 10 * level
	if card_type == FIREBALL:
		effects[HEALTH] += -10 * level		
	return effects

func update_state():
	var material = get_material()
	if material != null:
		material.set_shader_param('grayscale', not enabled)
	set_texture(textures[card_type])

func enable():
	set_enabled(true)
	return self

func disable():
	set_enabled(false)
	return self
	
func select():
	emit_signal("selected", self)
	
func deselect():
	emit_signal("deselected", self)
	
func _ready():
	randomize()
	var material = CanvasItemMaterial.new()
	material.set_shader(grayscaleMaterialShader)
	set_material(material)
	update_state()
	get_node("AnimationPlayer").connect("finished", self, "animation_finished")

func set_enabled(newenabled):
	enabled = newenabled
	update_state()

func set_card_type(newcardtype):
	card_type = newcardtype
	update_state()
	return self

func _on_Button_pressed():
	if enabled:
		game.set_selected_card(self)

func use():
	disappear()
	
func random():
	var randomIndex = randi() % types.size()
	self.set_card_type(types[randomIndex])

func appear():
	set_pos(Vector2(0, 140))
	current_animation = "popup"
	get_node("AnimationPlayer").play(current_animation)
	
	
func animation_finished():
	if current_animation == "popup":
		emit_signal("appeared", self)
	elif current_animation == "disappear":
		emit_signal("disappeared", self)

func upgrade():
	level += 1

func disappear():
	var player = get_node("AnimationPlayer")
	player.connect("finished", self, "destroy")
	current_animation = "disappear"
	player.play(current_animation)
	