extends Resource
class_name CharacterClass

export(Resource) var startingWeapon
export(Resource) var startingAbility
export(Resource) var startingArmor
export(Resource) var startingRing
export(Array, Resource) var startingAdditionalItems

export(Dictionary) var statsPerLevel = {
	"hp": 25,
	"mp": 25,
	"att": 5,
	"dex": 5,
	"spd": 5,
	"vit": 5,
	"wis": 5,
	"def": 5,
}

export(Dictionary) var statsLimit = {
	"hp": 700,
	"mp": 300,
	"att": 150,
	"dex": 150,
	"spd": 150,
	"vit": 150,
	"wis": 150,
	"def": 150,
}

export(Dictionary) var statsStarting = {
	"hp": 200,
	"mp": 250,
	"att": 100,
	"dex": 50,
	"spd": 75,
	"vit": 50,
	"wis": 50,
	"def": 0,
}
