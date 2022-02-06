extends ColorRect

var inventory = preload("res://Inventory.tres")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

onready var cursor = get_parent().get_parent().get_node("Cursor")
#onready var player = get_parent()

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
	cursor.texture = null
	#print(player.usedWeapon)
	#player.setWeaponByName(data.item.codeName)
	#print(player.usedWeapon)
