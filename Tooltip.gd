extends Popup

var slot = 0
var canShowItem = false

var inventory = preload("res://Inventory.tres")
onready var Container = get_node("NinePatchRect/MarginContainer/VBoxContainer")

func _process(_delta):
	rect_position = get_global_mouse_position() - Vector2(250, 350)

func _ready():
	var itemData
	if inventory.items[slot]:
		canShowItem = true
		itemData = inventory.items[slot]
		if itemData.itemType == "weapon":
			Container.get_node("ItemName").set_text(str(itemData.name, " (T", itemData.tier,")"))
			Container.get_node("ItemType").set_text(str(itemData.itemType," - ", itemData.weaponType))
			Container.get_node("Stat1/Stat").set_text(str("damage: ",itemData.dmg_min," - ",itemData.dmg_max))
			var i = 2
			if itemData.shots != 1:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("shots: ", itemData.shots))
				i+=1
			if itemData.angle:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("angle: ", itemData.angle))
				i+=1
			if itemData.multihit:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("pierces enemies"))
				i+=1
			if itemData.armorPierce:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("pierces armor"))
				i+=1
			if itemData.ignoreWalls:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("pierces walls"))
				i+=1
			for j in ["maxHp", "maxMana", "att", "dex", "spd", "vit", "wis", "def"]:
				if itemData[j]:
					Container.get_node(str("Stat",i,"/Stat")).set_text(str(j,": ", itemData.j))
					i+=1
