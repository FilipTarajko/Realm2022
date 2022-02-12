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
	var item_index = int(name)
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

# what was it for?
#func _ready():
#	player.setWeapon(inventory.items[4])

func drop_data(_position, data):
	#print(name)
	var item_index = int(name)
	var canBePutThere = true
	if name=="0":
		#print("This is the weapon slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="weapon"
	elif name=="1":
		#print("This is the ability slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="ability"
	elif name=="2":
		#print("This is the armor slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="armor"
	elif name=="3":
		#print("This is the ring slot!")
		canBePutThere = inventory.items[data.item_index].itemType=="ring"
	#print(str("Taking item from slot ",item_index))
	if not canBePutThere:
		print(str("You cannot put ",inventory.items[data.item_index].itemType," in this slot!"))
	if canBePutThere and data.item_index<4:
		print("Taking item from equipment slot!")
		if inventory.items[item_index]:
			if data.item_index == 0:
				canBePutThere = inventory.items[item_index].itemType=="weapon"
			elif data.item_index == 1:
				canBePutThere = inventory.items[item_index].itemType=="ability"
			elif data.item_index == 2:
				canBePutThere = inventory.items[item_index].itemType=="armor"
			elif data.item_index == 3:
				canBePutThere = inventory.items[item_index].itemType=="ring"
		if not canBePutThere:
			print(str("That would put a ",inventory.items[item_index].itemType," in incorrect item slot!"))
	#print(canBePutThere)
	if not canBePutThere:
		Cursor.texture = null
		return
	#var item = inventory.items[item_index]
	var lootbag = player.check_for_nearby_bags()
	if lootbag:
		if item_index>=12:
			#print("putting into lootbag!")
			lootbag.items[item_index-12] = inventory.items[data.item_index]
		if data.item_index>=12:
			#print("taking out of lootbag!")
			lootbag.items[data.item_index-12] = inventory.items[item_index]
			lootbag.check_for_deletion()
	if not lootbag:
		if item_index>=12:
			#print("creating lootbag!")
			var itemsToPutInLootbag = [null, null, null, null, null, null, null, null]
			itemsToPutInLootbag[item_index-12] = inventory.items[data.item_index]
			create_lootbag(itemsToPutInLootbag)
	inventory.swap_items(item_index, data.item_index)
	inventory.set_item(item_index, data.item)
	player.read_data_from_inventory()


var lootbagPrefab = preload("res://Prefabs/lootbag.tscn")


func create_lootbag(itemsToPutInLootbag):
	var newLootbag = lootbagPrefab.instance()
	newLootbag.items = itemsToPutInLootbag
	for _i in range(len(itemsToPutInLootbag), 8):
		newLootbag.items.append(null)
	newLootbag.global_position = player.global_position
	player.get_parent().add_child(newLootbag)

func _on_ItemTextureRect_mouse_entered():
	var newToolTip = toolTip.instance()
	newToolTip.slot = int(name)
	add_child(newToolTip)
	if has_node("Tooltip") and get_node("Tooltip").canShowItem:
		get_node("Tooltip").show()

func _on_ItemTextureRect_mouse_exited():
	get_node("Tooltip").free()
