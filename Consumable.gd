extends Item
class_name Consumable

export(float) var hpHealed = 0
export(float) var mpRestored = 0
export(float) var usesTotal = 1
export(float) var usesLeft = 1
export(Dictionary) var statsIncrease = {
	"hp": 0,
	"mp": 0,
	"att": 0,
	"dex": 0,
	"spd": 0,
	"vit": 0,
	"wis": 0,
	"def": 0,
}
export(String) var itemType = "consumable"
