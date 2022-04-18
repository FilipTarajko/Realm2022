extends KinematicBody2D

var move_directon = Vector2(0, 0)

var remaining_weapon_cooldown = 0
var remaining_ability_cooldown = 0
var invisibility = 0
var rotationSpeed = 90

var hp
var mp

### SETTINGS ? ###
var autofire = false

### NEGATIVE EFFECTS ###

var slowed = 0.0
var slowMultiplier = 2.0
var paralyzed = 0.0
var darzaConfused = 0.0

func applySlow(slowDuration):
	slowed = max(slowed, slowDuration)

func applyParalyze(paralyzeDuration):
	paralyzed = max(paralyzed, paralyzeDuration)

func applyDarzaConfuse(darzaConfuseDuration):
	darzaConfused = max(darzaConfused, darzaConfuseDuration)

onready var effectsHUDContainer = get_node("TemporaryEffectsDisplay/HBoxContainer")

func handleNegativeEffects(delta):
	if slowed:
		slowed = max(slowed-delta, 0)
		effectsHUDContainer.get_node("slowed").visible = true
		if slowed < 1:
			effectsHUDContainer.get_node("slowed").modulate = Color(1, 1, 1, slowed)
		else:
			effectsHUDContainer.get_node("slowed").modulate = Color(1, 1, 1, 1)
	else:
		effectsHUDContainer.get_node("slowed").visible = false
	if paralyzed:
		paralyzed = max(paralyzed-delta, 0)
		effectsHUDContainer.get_node("paralyzed").visible = true
		if paralyzed < 1:
			effectsHUDContainer.get_node("paralyzed").modulate = Color(1, 1, 1, paralyzed)
		else:
			effectsHUDContainer.get_node("paralyzed").modulate = Color(1, 1, 1, 1)
	else:
		effectsHUDContainer.get_node("paralyzed").visible = false
	if darzaConfused:
		darzaConfused = max(darzaConfused-delta, 0)
		effectsHUDContainer.get_node("darzaConfused").visible = true
		if darzaConfused < 1:
			effectsHUDContainer.get_node("darzaConfused").modulate = Color(1, 1, 1, darzaConfused)
		else:
			effectsHUDContainer.get_node("darzaConfused").modulate = Color(1, 1, 1, 1)
	else:
		effectsHUDContainer.get_node("darzaConfused").visible = false

### STATS ###

func calculateExperienceToNextLevel():
	experienceToNextLevel = 50+100*level

func updateExperienceBar():
	$CanvasLayer/UIBars/UIExpbar/Label3.text = str(experience,"/",experienceToNextLevel)
	$CanvasLayer/UIBars/UIExpbar.value = 100*experience/experienceToNextLevel

var stats = ["hp", "mp", "att", "dex", "spd", "vit", "wis", "def"]

var characterClass = load("res://Assets/Classes/tester.tres")

var statsPerLevel = {
#	'hp': 25,
#	'mp': 25,
#	'att': 5,
#	'dex': 5,
#	'spd': 5,
#	'vit': 5,
#	'wis': 5,
#	'def': 5,
}

var statsLimit = {
#	'hp': 700,
#	'mp': 300,
#	'att': 150,
#	'dex': 150,
#	'spd': 150,
#	'vit': 150,
#	'wis': 150,
#	'def': 150,
}

var statsStarting = {
#	'hp': 200,
#	'mp': 250,
#	'att': 100,
#	'dex': 50,
#	'spd': 75,
#	'vit': 50,
#	'wis': 50,
#	'def': 0,
}

onready var statsVBoxContainer = get_node("CanvasLayer/statsPanel/NinePatchRect/MarginContainer/VBoxContainer")

func readStatsFromCharacterClass():
	for stat in stats:
		statsPerLevel[stat] = characterClass.statsPerLevel[stat]
		statsLimit[stat] = characterClass.statsLimit[stat]
		statsVBoxContainer.get_node(stat).get_node("statMax").text = str(characterClass.statsLimit[stat])
		statsStarting[stat] = characterClass.statsStarting[stat]

var statsBase = {}
var statsTotal = {}
var statsFromItems = {}

func addBaseStats(statsGained):
	for stat in stats:
		if stat in statsGained:
			statsBase[stat] = min(statsBase[stat]+statsGained[stat], statsLimit[stat])
		statsVBoxContainer.get_node(stat).get_node("statBase").text = str(statsBase[stat])
		statsVBoxContainer.get_node(stat).get_node("statLeftToMax").text = str(characterClass.statsLimit[stat]-statsBase[stat])

func levelUp():
	level+=1
	addBaseStats(statsPerLevel)
	recalculateTotalStats()
	hp = statsTotal["hp"]
	mp = statsTotal["mp"]

func gainExperience(experienceGained):
	experience += experienceGained
	if level<levelLimit and experience >= experienceToNextLevel:
		while level<levelLimit and experience >= experienceToNextLevel:
			levelUp()
			experience -= experienceToNextLevel
			calculateExperienceToNextLevel()
		spawnFloatingTextMessage(str("Level ",level," achieved!"), Color(0.0, 0.8, 0.4, 1.0))
	updateExperienceBar()

var levelLimit = 50
var level = 1
var experience = 0
var experienceToNextLevel

# att multiplies damage by att/100
# dex multiplies RoF by dex/10
# spd moves spd/10 tiles/s
# vit regenerates vit/10 hp/s
# wis regenerates wis/10 mana/s
# def reduces damage from hit by def

func recalculateItemStatBonuses():
	var statsCalculated = {}
	for stat in stats:
		statsCalculated[stat] = 0
		for i in range(0, 4):
			if inventory.items[i]:
				statsCalculated[stat]+=inventory.items[i][stat]
		statsFromItems[stat] = statsCalculated[stat]
		statsVBoxContainer.get_node(stat).get_node("statItems").text = str(statsFromItems[stat])
		

func recalculateTotalStats():
	for stat in stats:
		statsTotal[stat] = statsBase[stat]+statsFromItems[stat]
		statsVBoxContainer.get_node(stat).get_node("statTotal").text = str(statsTotal[stat])
	if hp:
		if hp>statsTotal["hp"]:
			hp = statsTotal["hp"]
	if mp:
		if mp>statsTotal["mp"]:
			mp = statsTotal["mp"]

var minimalTakenDamageMultiplier = 0.15

var usedWeapon
var usedAbility
var usedArmor
var usedRing

func setWeapon(weapon):
	usedWeapon = weapon
	
func setAbility(ability):
	usedAbility = ability

func setArmor(armor):
	usedArmor = armor

func setRing(ring):
	usedRing = ring

func loadStartingCharacterClassItemToInventory():
	inventory.set_item(0, characterClass.startingWeapon)
	inventory.set_item(1, characterClass.startingAbility)
	inventory.set_item(2, characterClass.startingArmor)
	inventory.set_item(3, characterClass.startingRing)
	for i in range(4, min(len(characterClass.startingAdditionalItems), 12)+4):
		inventory.set_item(i, characterClass.startingAdditionalItems[i-4])

func _ready():
	readStatsFromCharacterClass()
	loadStartingCharacterClassItemToInventory()
	for stat in stats:
		statsBase[stat] = statsStarting[stat]
	read_data_from_inventory()
	recalculateItemStatBonuses()
	recalculateTotalStats()
	hp = statsTotal["hp"]
	mp = statsTotal["mp"]
	randomize()
	checkIfDead()
	calculateExperienceToNextLevel()
	updateExperienceBar()

func _physics_process(delta):
	handleMovement()
	handleRotation(delta)
	handleNegativeEffects(delta)

func update_bars():
	if not checkIfDead():
		# hp
		$Healthbar.value = 100*hp/statsTotal["hp"]
		$CanvasLayer/UIBars/UIHealthbar/Label.text = str(round(hp),"/",statsTotal["hp"])
		$CanvasLayer/UIBars/UIHealthbar.value = 100*hp/statsTotal["hp"]
		# mp
		$Manabar.value = 100*mp/statsTotal["mp"]
		$CanvasLayer/UIBars/UIManabar/Label2.text = str(round(mp),"/",statsTotal["mp"])
		$CanvasLayer/UIBars/UIManabar.value = 100*mp/statsTotal["mp"]

func checkIfDead():
	if hp<=0 or statsTotal['hp']<=0:
		print("\nYou were defeated! Game restarted!")
		var _ignore = get_tree().reload_current_scene()
		return true

func _process(delta):
	checkIfDead()
	hp=min(statsTotal["hp"], hp+(statsTotal["vit"]/10)*delta)
	mp=min(statsTotal["mp"], mp+(statsTotal["wis"]/10)*delta)
	handleRestarting()
	handleItemUse()
	handleAnimation()
	handleAbilityUse(delta)
	handleWeaponShooting(delta)
	update_bars()
	check_for_nearby_bags()


func check_for_nearby_bags():
	var lootbags = []
	for i in get_parent().get_children():
		if "Lootbag" in i.name:
			lootbags.append(i)
	if lootbags:
		var closestBagIndex = 0
		var minDistance = lootbags[0].global_position.distance_to(global_position)/8
		for i in len(lootbags):
			var distance = lootbags[i].global_position.distance_to(global_position)/8
			if distance < minDistance:
				closestBagIndex = i
				minDistance = distance
		if minDistance < 1:
			for i in range(12, 20):
				if lootbags[closestBagIndex].items[i-12]:
					inventory.set_item(i, lootbags[closestBagIndex].items[i-12])
				else:
					inventory.set_item(i, null)
				setVisibilityOfBagSlots(true)
			return lootbags[closestBagIndex]
		else:
			for i in range(12, 20):
				inventory.remove_item(i)
				setVisibilityOfBagSlots(false)
			return false
	else:
		for i in range(12, 20):
			inventory.remove_item(i)
			setVisibilityOfBagSlots(false)
	return false

func setVisibilityOfBagSlots(value):
#	print(get_node(str("CanvasLayer/InventoryParent/InventoryContainer/CenterContainer/InventoryDisplay/")))
	var color = Color(1, 1, 1, 0)
	if value:
		color = Color(1, 1, 1, 1)
	for i in range(12, 20):
		get_node(str("CanvasLayer/InventoryParent/InventoryContainer/CenterContainer/InventoryDisplay/",i)).modulate = color

var inventory = preload("res://Inventory.tres")
onready var cursor = get_node("CanvasLayer/Cursor")

func show_equipment_in_console():
	var stuff = {0: "weapon", 1: "ability", 2: "armor", 3: "ring"}
	for i in range(0,4):
		var napis = "empty"
		if inventory.items[i]:
			napis = inventory.items[i].name
		print(str("[",i,"] ", stuff[i],": ",napis))

func read_data_from_inventory():
	#show_equipment_in_console()
	setWeapon(inventory.items[0])
	setAbility(inventory.items[1])
	setArmor(inventory.items[2])
	setRing(inventory.items[3])
	cursor.texture = null
	recalculateItemStatBonuses()
	recalculateTotalStats()


func heal(hpHealed):
	hp = min(hp+hpHealed, statsTotal["hp"])
	spawnFloatingTextMessage(str("+",hpHealed,"hp!"), Color(1.0, 0.8, 0.8, 1.0))


func restoreMana(mpRestored):
	mp = min(mp+mpRestored, statsTotal["mp"])
	spawnFloatingTextMessage(str("+",mpRestored,"mp!"), Color(0.8, 0.8, 1.0, 1.0))


func useConsumableItem(item, slot):
	print(item.name)
	if item.hpHealed:
		heal(item.hpHealed)
	if item.mpRestored:
		restoreMana(item.mpRestored)
	for key in item.statsIncrease:
		if item.statsIncrease[key]!=0:
			spawnFloatingTextMessage(str(key," +",min(statsBase[key]+item.statsIncrease[key], statsLimit[key])-statsBase[key],"!"), Color(1.0, 1.0, 1.0, 1.0))
	addBaseStats(item.statsIncrease)
	recalculateTotalStats()
	if item.usesTotal:
		item.usesLeft -= 1
		if item.usesLeft <= 0:
			inventory.remove_item(slot)

func handleItemUse():
	for i in range(1, 9):
		if Input.is_action_just_pressed(str(i)):
			var slot
			if i<=8:
				slot = i+3
				if inventory.items[slot]:
					#print(str("Trying to use item: ", inventory.items[slot].name)
					if inventory.items[slot].itemType == "consumable":
						print("That's a consumable!")
						useConsumableItem(inventory.items[slot], slot)
					elif inventory.items[slot].itemType == "weapon":
						print("That's a weapon!")
						inventory.swap_items(slot, 0)
						read_data_from_inventory()
					elif inventory.items[slot].itemType == "ability":
						print("That's an ability!")
						inventory.swap_items(slot, 1)
						read_data_from_inventory()
					elif inventory.items[slot].itemType == "armor":
						print("That's an armor!")
						inventory.swap_items(slot, 2)
						read_data_from_inventory()
					elif inventory.items[slot].itemType == "ring":
						print("That's a ring!")
						inventory.swap_items(slot, 3)
						read_data_from_inventory()
				else:
					print("You are trying to use empty inventory slot!")

var floatingDamage = load("res://PlayerFloatingDamage.tscn")
var floatingDamage2 = load("res://FloatingText.tscn")

func spawnFloatingTextMessage(message, startColor = Color(0.8, 0.7, 0.2, 1.0), addedPosition = Vector2(0, -15)):
	var newFloatingDamage = floatingDamage2.instance()
	newFloatingDamage.get_node("DamageLabel").text = message
	newFloatingDamage.startColor = startColor
	newFloatingDamage.position += addedPosition
	newFloatingDamage.alphaStartTime = 0.8
	newFloatingDamage.player = self
	#newFloatingDamage.position = position #global_position #- Vector2(20 + rand_range(-5, 5), 30 + rand_range(-2, 6))
	#newFloatingDamage.rect_scale = Vector2(0.2, 0.2)
	add_child(newFloatingDamage)

func spawnDamageFloatingText2(damage, ignoringArmor):
	var newFloatingDamage = floatingDamage2.instance()
	newFloatingDamage.get_node("DamageLabel").text=str(round(damage))
	if ignoringArmor:
		newFloatingDamage.startColor = Color(1, rand_range(0.0, 0.4), rand_range(0.6, 0.8), 1)
	else:
		newFloatingDamage.startColor = Color(1, rand_range(0.0, 0.4), rand_range(0.0, 0.2), 1)
	newFloatingDamage.position += Vector2(rand_range(-3, 3), rand_range(-20, -10))
	newFloatingDamage.player = self
	#newFloatingDamage.position = position #global_position #- Vector2(20 + rand_range(-5, 5), 30 + rand_range(-2, 6))
	#newFloatingDamage.rect_scale = Vector2(0.2, 0.2)
	add_child(newFloatingDamage)
	
func spawnDamageFloatingText(damage):
	var newFloatingDamage = floatingDamage.instance()
	newFloatingDamage.text=str(round(damage))
	newFloatingDamage.rect_position = - Vector2(20 + rand_range(-5, 5), 30 + rand_range(-2, 6))
	newFloatingDamage.targetModulateR = 1.0
	newFloatingDamage.targetModulateG = 0.0
	newFloatingDamage.targetModulateB = 0.0
	#newFloatingDamage.rect_scale = Vector2(0.2, 0.2)
	add_child(newFloatingDamage)

func takeDamage(damage, ignoringArmor, enemyName, enemyAttackName):
	var damageToDeal
	if ignoringArmor:
		damageToDeal = damage
#		print(str("Took ",damageToDeal," armor-ignoring damage from ", enemyName, "'s ",enemyAttackName,"!"))
		spawnDamageFloatingText2(damageToDeal, true)
	else:
#		print(str("statsBase def:", statsBase["def"]))
#		print(str("statsFromItems def:", statsFromItems["def"]))
#		print(str("statsTtdef:", statsTotal["def"]))
		damageToDeal = max(damage-statsTotal["def"], damage*minimalTakenDamageMultiplier)
#		print(str("Took ",damageToDeal," (",damage,") damage from ", enemyName, "'s ",enemyAttackName,"!"))
		spawnDamageFloatingText2(damageToDeal, false)
	hp-=damageToDeal

func handleRestarting():
	if Input.is_key_pressed(KEY_R):
		print("\nRestarted!")
		var _ignore = get_tree().reload_current_scene()


var arrowPrefab = preload("res://Prefabs/PlayerArrow.tscn")

var textureDown = preload("res://Assets/playerSprites/archerGreen.png")
var textureUp = preload("res://Assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://Assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://Assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func handleMovement():
	if not paralyzed:
		move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
		move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
		var movement = move_directon.normalized()*statsTotal["spd"]*0.8
		if slowed:
			movement/=slowMultiplier
		# move_and_slide has delta built-in
		if darzaConfused:
			var _ignore = move_and_slide(movement.rotated(rotation+deg2rad(90)))
		else:
			var _ignore = move_and_slide(movement.rotated(rotation))


func handleRotation(delta):
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0


func handleAnimation():
	if darzaConfused:
		if Input.is_action_pressed("Right"):
			sprite_node.texture=textureDown
		elif Input.is_action_pressed("Left"):
			sprite_node.texture = textureUp
		elif Input.is_action_pressed("Up"):
			sprite_node.texture = textureRight
		elif Input.is_action_pressed("Down"):
			sprite_node.texture = textureLeft
	else:
		if Input.is_action_pressed("Down"):
			sprite_node.texture=textureDown
		elif Input.is_action_pressed("Up"):
			sprite_node.texture = textureUp
		elif Input.is_action_pressed("Right"):
			sprite_node.texture = textureRight
		elif Input.is_action_pressed("Left"):
			sprite_node.texture = textureLeft


var bombPrefab = preload("res://Prefabs/bombPrefab.tscn")

func generateBombs(shootingWeapon, targetPosition):
	var new_bomb = bombPrefab.instance()
	new_bomb.target_position = targetPosition
	if shootingWeapon.fallsFromAbove:
		new_bomb.get_node("FallingBomb").process_material = preload("res://Prefabs/bombFromAboveMaterial.tres")
	else:
		new_bomb.get_node("FallingBomb").process_material = preload("res://Prefabs/bombParabolicMaterial.tres")
	new_bomb.rotation = get_parent().get_node("Player").rotation
	new_bomb.dmg = rand_range(shootingWeapon.dmg_min, shootingWeapon.dmg_max)*statsTotal["att"]/100.0
	new_bomb.armorPierce = shootingWeapon.armorPierce
	new_bomb.slowDuration = shootingWeapon.slowDuration
	new_bomb.paralyzeDuration = shootingWeapon.paralyzeDuration
	new_bomb.fallingTime = shootingWeapon.flightTimeBase
	new_bomb.impactRadius = shootingWeapon.impactRadius
	new_bomb.fallsFromAbove = shootingWeapon.fallsFromAbove
	new_bomb.throwerPosition = global_position
	new_bomb.color = shootingWeapon.modulate
	new_bomb.targetsPlayer = false
	if shootingWeapon.flightTimePerTile:
		new_bomb.fallingTime += shootingWeapon.flightTimePerTile * global_position.distance_to(targetPosition)/8.0
	get_parent().add_child(new_bomb)


var weapon_bullets_shot = 0

func generateBullets(shootingWeapon, position):
	for i in range(shootingWeapon.shots):
		var new_arrow = arrowPrefab.instance()
		new_arrow.position = position
		new_arrow.projectile_speed = shootingWeapon.projectile_speed
		new_arrow.projectile_acceleration = shootingWeapon.projectile_acceleration
		new_arrow.lifetime = shootingWeapon.lifetime
		new_arrow.damage = rand_range(shootingWeapon.dmg_min, shootingWeapon.dmg_max)*statsTotal["att"]/100.0
		new_arrow.rotation = (get_angle_to(get_global_mouse_position())+PI/2+deg2rad((i-((shootingWeapon.shots-1)/2))*((shootingWeapon.angle)/(shootingWeapon.shots))))+(rotation)
		new_arrow.get_child(1).texture = shootingWeapon["bulletSprite"]
		new_arrow.modulate = shootingWeapon.modulate
		new_arrow.scale.x = shootingWeapon.scalex
		new_arrow.scale.y = shootingWeapon.scaley
		new_arrow.armorPierce = shootingWeapon.armorPierce
		new_arrow.bulletWaveFrequency = shootingWeapon.bulletWaveFrequency
		new_arrow.bulletWaveAmplitude = shootingWeapon.bulletWaveAmplitude
		if shootingWeapon.ignoreWalls:
			new_arrow.collision_mask-=2
			new_arrow.get_node("Sprite").z_index+=2
		new_arrow.multihit = shootingWeapon.multihit
		if "slowDuration" in shootingWeapon:
			new_arrow.slowDuration = shootingWeapon.slowDuration
		if "paralyzeDuration" in shootingWeapon:
			new_arrow.paralyzeDuration = shootingWeapon.paralyzeDuration
		new_arrow.get_child(0).shape.radius = shootingWeapon.collisionShapeRadius
		new_arrow.get_child(0).shape.height = shootingWeapon.collisionShapeHeight
		new_arrow.get_child(1).rotation_degrees = shootingWeapon.spriteRotation
		new_arrow.get_child(1).position.x = shootingWeapon.spriteOffsetX
		new_arrow.get_child(1).position.y = shootingWeapon.spriteOffsetY
		new_arrow.indexOfWeaponsBullet = weapon_bullets_shot
		weapon_bullets_shot += 1
		get_parent().add_child(new_arrow)

func handleAbilityUse(delta):
	if remaining_ability_cooldown > 0:
		remaining_ability_cooldown -= delta
		return
	if not Input.is_action_just_pressed("Ability"):
		return
	if not inventory.items[1]:
		spawnFloatingTextMessage("no ability equipped!")
		return
	if mp < usedAbility.manaCost:
		spawnFloatingTextMessage("no mana!", Color(0.5, 0.6, 0.9, 1.0))
		return
	remaining_ability_cooldown = usedAbility.cooldown
	mp -= usedAbility.manaCost
	if usedAbility.abilityType == "scroll":
		generateBullets(usedAbility, get_global_mouse_position())
	if usedAbility.abilityType == "quiver":
		generateBullets(usedAbility, get_global_position())
	if usedAbility.abilityType == "poison":
		generateBombs(usedAbility, get_global_mouse_position())

func handleWeaponShooting(delta):
	if Input.is_action_just_pressed("i"):
		autofire = !autofire
	if remaining_weapon_cooldown > 0:
		remaining_weapon_cooldown -= delta
		return
	if (not autofire and not Input.is_action_pressed("Shoot")):
		return
	if not inventory.items[0]:
		spawnFloatingTextMessage("no weapon equipped!")
		return
	remaining_weapon_cooldown = 1.0/usedWeapon.rateOfFire*10.0/statsTotal["dex"]
	generateBullets(usedWeapon, get_global_position())


func _on_statsToggle_pressed():
	$CanvasLayer/statsPanel.visible = !$CanvasLayer/statsPanel.visible


func _on_inventoryToggle_pressed():
	$CanvasLayer/InventoryParent/InventoryContainer.visible = !$CanvasLayer/InventoryParent/InventoryContainer.visible
