tool

extends Control

const grayscaleMaterialShader = preload('shaders/GrayscaleMaterialShader.tres')

const HEALTH = 'health'
const ATTACK = 'attack'
const DEFENCE = 'defence'
const SPEED = 'speed'

export(String, "health", "attack", "defence", "speed") var card_type = HEALTH setget set_card_type
export var enabled = true setget set_enabled

onready var texture_frame = get_node("TextureFrame")

var textures = {
	HEALTH: load('res://assets/blue.png'),
	ATTACK: load('res://assets/green.png'),
	DEFENCE: load('res://assets/orange.png'),
	SPEED: load('res://assets/purp.png'),
}

func update_state():
	if texture_frame == null:
		return
	
	texture_frame.get_material().set_shader_param('grayscale', not enabled)
	texture_frame.set_texture(textures[card_type])

func enable():
	set_enabled(true)
	return self

func disable():
	set_enabled(false)
	return self
	
func _ready():
	var material = CanvasItemMaterial.new()
	material.set_shader(grayscaleMaterialShader)
	texture_frame.set_material(material)
	update_state()

func set_enabled(newenabled):
	enabled = newenabled
	update_state()

func set_card_type(newcardtype):
	card_type = newcardtype
	update_state()
	return self