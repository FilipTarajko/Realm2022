extends ColorRect

var inventory = preload("res://Inventory.tres")
onready var player = get_parent().get_parent()

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

onready var cursor = get_parent().get_node("Cursor")
#onready var player = get_parent()


var lootbag = preload("res://Prefabs/lootbag.tscn")

func create_lootbag(itemsToPutInLootbag):
	var newLootbag = lootbag.instance()
	newLootbag.items = itemsToPutInLootbag
	for _i in range(len(itemsToPutInLootbag), 8):
		newLootbag.items.append(null)
	newLootbag.global_position = player.global_position
	player.get_parent().add_child(newLootbag)


func drop_data(_position, data):
	
	# was this doing something?
	#inventory.set_item(data.item_index, data.item)
	
	# drop item into a bag
	if data.item_index < 12:
		var nearestReachableBag = player.check_for_nearby_bags()
		if nearestReachableBag and (null in nearestReachableBag.items):
			for i in range(8):
				print(i)
				if nearestReachableBag.items[i]:
					print(str("Nearest reachable bag [",i,"] = ",nearestReachableBag.items[i]))
				if not nearestReachableBag.items[i]:
					print(str("Nearest reachable bag [",i,"] = ",nearestReachableBag.items[i]))
					nearestReachableBag.items[i] = data.item
					inventory.remove_item(data.item_index)
					break
		else:
			var itemsToPutInLootbag = [data.item, null, null, null, null, null, null, null]
			create_lootbag(itemsToPutInLootbag)
			inventory.remove_item(data.item_index)
	
	# debug
#	print(str("drop_data: data.item_index = ",data.item_index, ", data.item: ",data.item))
	
	cursor.texture = null
