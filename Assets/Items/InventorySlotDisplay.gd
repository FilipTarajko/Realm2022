extends CenterContainer

var inventory = preload("res://Assets/Items/Inventory.tres")

onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = load("res://Assets/Items/emptyInventorySlot.png")

onready var Cursor = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Cursor")
onready var player = get_parent().get_parent().get_parent().get_parent().get_parent()

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.items[item_index]
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		Cursor.texture = item.texture
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

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
	if(inventory.items[4]):
		player.setWeaponByName(inventory.items[4].codeName)
	else:
		player.setWeaponByName("bow_t0")
	Cursor.texture = null
