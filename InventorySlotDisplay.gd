extends CenterContainer

var inventory = preload("res://Inventory.tres")

onready var toolTip = preload("res://Tooltip.tscn")
onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.itemSprite
	else:
		itemTextureRect.texture = load("res://Assets/ItemSprites/emptyInventorySlot.png")

onready var Cursor = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Cursor")
onready var player = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

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
	#print("sprawdzam cos")
	#var canBeDropped
	#canBeDropped = true
	#if not canBeDropped:
	#	Cursor.texture=null
	#return canBeDropped
	return data is Dictionary and data.has("item")

func _ready():
	inventory.set_item(4, load("res://Assets/Items/bow_t0.tres"))
	player.setWeapon(inventory.items[4])

func drop_data(_position, data):
	#print(name)
	var item_index = get_index()
	var canBePutThere = true
	if name=="4":
		#print("This is the weapon slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="weapon"
	elif name=="5":
		#print("This is the ability slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="ability"
	elif name=="6":
		#print("This is the armor slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="armor"
	elif name=="7":
		#print("This is the ring slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="ring"
	#print(str("Taking item from slot ",item_index))
	if not canBePutThere:
		print(str("You cannot put ",inventory.items[data.item_index].itemType," in this slot!"))
	if canBePutThere and data.item_index>3 and data.item_index<8:
		print("Taking item from equipment slot!")
		if data.item_index == 4:
			canBePutThere = inventory.items[item_index].itemType=="weapon"
		elif data.item_index == 5:
			canBePutThere = inventory.items[item_index].itemType=="ability"
		elif data.item_index == 6:
			canBePutThere = inventory.items[item_index].itemType=="armor"
		elif data.item_index == 7:
			canBePutThere = inventory.items[item_index].itemType=="ring"
		if not canBePutThere:
			print(str("That would put a ",inventory.items[item_index].itemType," in incorrect item slot!"))
	#print(canBePutThere)
	if not canBePutThere:
		Cursor.texture = null
		return
	var item = inventory.items[item_index]
	inventory.swap_items(item_index, data.item_index)
	inventory.set_item(item_index, data.item)
	player.read_data_from_inventory()



func _on_ItemTextureRect_mouse_entered():
	var newToolTip = toolTip.instance()
	newToolTip.slot = int(name)
	add_child(newToolTip)
	if has_node("Tooltip") and get_node("Tooltip").canShowItem:
		get_node("Tooltip").show()

func _on_ItemTextureRect_mouse_exited():
	get_node("Tooltip").free()
