extends Popup

var slot = 0
var canShowItem = false

var inventory = preload("res://Inventory.tres")
onready var Container = get_node("NinePatchRect/MarginContainer/VBoxContainer")

func _process(_delta):
	rect_position = get_global_mouse_position() - Vector2(250, 370)

func showNameAndTier(itemData):
	var tier = itemData.tier
	if tier.length() == 1:
		tier=str("T",tier)
	Container.get_node("ItemName").set_text(str(itemData.name, " (", tier,")"))

func showBonusStats(itemData, i):
	for j in ["def", "hp", "mp", "att", "dex", "spd", "vit", "wis" ]:
		if itemData[j]:
			Container.get_node(str("Stat",i,"/Stat")).set_text(str(j,": ", itemData[j]))
			i+=1

func _ready():
	var itemData
	if inventory.items[slot]:
		canShowItem = true
		itemData = inventory.items[slot]
		if itemData.itemType == "weapon":
			showNameAndTier(itemData)
			Container.get_node("ItemType").set_text(str(itemData.itemType," - ", itemData.weaponType))
			Container.get_node("Stat1/Stat").set_text(str("damage: ",itemData.dmg_min," - ",itemData.dmg_max))
			var i = 2
			Container.get_node(str("Stat",i,"/Stat")).set_text(str("range: ", itemData.lifetime*itemData.projectile_speed))
			i+=1
			if itemData.rateOfFire != 1:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("rate of fire: ", itemData.rateOfFire))
				i+=1
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
			showBonusStats(itemData, i)
		if itemData.itemType == "armor":
			showNameAndTier(itemData)
			Container.get_node("ItemType").set_text(str(itemData.itemType," - ", itemData.armorType))
			showBonusStats(itemData, 1)
		if itemData.itemType == "ring":
			showNameAndTier(itemData)
			Container.get_node("ItemType").set_text(itemData.itemType)
			showBonusStats(itemData, 1)
		if itemData.itemType == "ability":
			showNameAndTier(itemData)
			Container.get_node("ItemType").set_text(itemData.itemType)
			var i = 1
			Container.get_node(str("Stat",i,"/Stat")).set_text(str("mana cost: ",itemData.manaCost))
			i+=1
			Container.get_node(str("Stat",i,"/Stat")).set_text(str("damage: ",itemData.dmg_min," - ",itemData.dmg_max))
			i+=1
			Container.get_node(str("Stat",i,"/Stat")).set_text(str("bullet's range: ", itemData.lifetime*itemData.projectile_speed))
			i+=1
			Container.get_node(str("Stat",i,"/Stat")).set_text(str("cooldown: ", itemData.cooldown, "s"))
			i+=1
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
			if itemData.paralyzeDuration:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("paralyzes enemies for ", itemData.paralyzeDuration, "s"))
				i+=1
			if itemData.slowDuration:
				Container.get_node(str("Stat",i,"/Stat")).set_text(str("slows enemies for ", itemData.slowDuration, "s"))
				i+=1
			if "additionalUsageInfo" in itemData:
				Container.get_node(str("Stat",i,"/Stat")).set_text(itemData.additionalUsageInfo)
				i+=1
			showBonusStats(itemData, i)
