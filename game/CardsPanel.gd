extends Node2D

const Card = preload("Card.tscn")

var selected_card = null
var cards = []

const CARD_SPAWN_TIMEOUT = 2
const MAXIUM_CARD_COUNT = 6
const CARD_WIDTH = 96
const CARD_HEIGHT = 128
const CARD_MARGIN = 9

func card_appeared(card):
	check_match()

func remove_card(card):
	var index = cards.find(card)
	if index >= 0:
		cards.remove(index)
		game.card_removed(card)
		var parent = card.get_parent()
		parent.free()
		for i in range(cards.size()):
			fix_card_position(i)

func card_disappeared(card):
	remove_card(card)
	check_match()
	
func card_selected(card):
	var position = card.get_pos() + Vector2(0, -15)
	card.set_pos(position)

func card_deselected(card):
	var position = card.get_pos() + Vector2(0, 15)
	card.set_pos(position)

func calculate_card_pos(idx):
	var count = idx
	var cards_width = count * CARD_WIDTH
	var margins =  (1 + count) * CARD_MARGIN
	return Vector2(cards_width + margins, 0)

func emit_card():
	if cards.size() >= MAXIUM_CARD_COUNT:
		return
		
	var card = Card.instance()
	card.random()
	cards.append(card)
	draw_card(cards.size() - 1)
	card.connect('selected', self, "card_selected")
	card.connect('deselected', self, "card_deselected")
	card.connect('appeared', self, "card_appeared")
	card.connect('disappeared', self, "card_disappeared")
	
func fix_card_position(idx):
	var card = cards[idx]
	var pos = calculate_card_pos(idx)
	var cardWrapper = card.get_parent()
	cardWrapper.set_pos(pos)

func draw_card(idx):
	var cardWrapper = Node2D.new()
	var card = cards[idx]
	var pos = calculate_card_pos(idx)
	cardWrapper.set_pos(pos)
	cardWrapper.add_child(card)
	card.set_owner(cardWrapper)
	add_child(cardWrapper)
	card.appear()

func check_match():
	var count = 0
	var type = null
	var level = null
	var start_index = null
	var current_index = 0
	for card in cards:
		if type == null or type != card.card_type or level != card.level:
			start_index = current_index
			count = 1
			type = card.card_type
			level = card.level
		else:
			count += 1
		
		current_index += 1
		if count == 3:
			match(start_index)
			return
			
func match(index):
	print('starting', index)
	cards[index+1].disappear()
	cards[index+1].disappear()
	cards[index].upgrade()

func _ready():
	emit_card()
	emit_card()
	while true:
		yield(game.wait(CARD_SPAWN_TIMEOUT), "timeout")
		emit_card()