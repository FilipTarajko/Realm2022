extends CenterContainer

var inventory = preload("res://Inventory.tres")

onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.itemSprite
	else:
		itemTextureRect.texture = load("res://Assets/ItemSprites/emptyInventorySlot.png")

onready var Cursor = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Cursor")
onready var player = get_parent().get_parent().get_parent().get_parent().get_parent()

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.items[item_index]
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		Cursor.texture = item.itemSprite
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func _ready():
	inventory.set_item(4, load("res://Assets/Items/bow_t0.tres"))
	player.setWeapon(inventory.items[4])

func drop_data(_position, data):
	var item_index = get_index()
	var item = inventory.items[item_index]
	inventory.swap_items(item_index, data.item_index)
	inventory.set_item(item_index, data.item)
	var stuff = {4: "weapon", 5: "ability", 6: "armor", 7: "ring"}
	for i in range(4,8):
		var napis = "empty"
		if inventory.items[i]:
			napis = inventory.items[i].name
		print(str("[",i,"] ", stuff[i],": ",napis))
	if not inventory.items[4]:
		inventory.set_item(4, load("res://Assets/Items/bow_t0.tres"))
	player.setWeapon(inventory.items[4])
	Cursor.texture = null
