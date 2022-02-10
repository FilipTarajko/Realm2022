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

func applySlow(slowDuration):
	slowed = max(slowed, slowDuration)
	
func applyParalyze(paralyzeDuration):
	paralyzed = max(paralyzed, paralyzeDuration)

func handleNegativeEffects(delta):
	if slowed:
		slowed = max(slowed-delta, 0)
	if paralyzed:
		paralyzed = max(paralyzed-delta, 0)

### STATS ###

func calculateExperienceToNextLevel():
	experienceToNextLevel = 50+100*level

func updateExperienceBar():
	$CanvasLayer/InventoryParent/InventoryContainer/UIBars/UIExpbar.value = 100*experience/experienceToNextLevel

var stats = ["hp", "mp", "att", "dex", "spd", "vit", "wis", "def"]

var statsPerLevel = {
	'hp': 25,
	'mp': 25,
	'att': 5,
	'dex': 5,
	'spd': 5,
	'vit': 5,
	'wis': 5,
	'def': 5,
}

var statsLimit = {
	'hp': 700,
	'mp': 300,
	'att': 150,
	'dex': 150,
	'spd': 150,
	'vit': 150,
	'wis': 150,
	'def': 150,
}

var statsStarting = {
	'hp': 200,
	'mp': 250,
	'att': 100,
	'dex': 50,
	'spd': 75,
	'vit': 50,
	'wis': 50,
	'def': 0,
}

var statsBase = {}
var statsTotal = {}
var statsFromItems = {}

func addBaseStats():
	for stat in stats:
		statsBase[stat] = min(statsBase[stat]+statsPerLevel[stat], statsLimit[stat])

func levelUp():
	level+=1
	addBaseStats()
	recalculateTotalStats()
	hp = statsTotal["hp"]
	mp = statsTotal["mp"]

func gainExperience(experienceGained):
	experience += experienceGained
	if experience >= experienceToNextLevel:
		while experience >= experienceToNextLevel:
			levelUp()
			experience -= experienceToNextLevel
			calculateExperienceToNextLevel()
		spawnFloatingTextMessage(str("Level ",level," achieved!"), Color(0.0, 0.8, 0.4, 1.0))
	updateExperienceBar()

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
		for i in range(4, 8):
			if inventory.items[i]:
				statsCalculated[stat]+=inventory.items[i][stat]
		statsFromItems[stat] = statsCalculated[stat]

func recalculateTotalStats():
	for stat in stats:
		statsTotal[stat] = statsBase[stat]+statsFromItems[stat]
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

func _ready():
	for stat in stats:
		statsBase[stat] = statsStarting[stat]
	read_data_from_inventory()
	recalculateItemStatBonuses()
	recalculateTotalStats()
	hp = statsTotal["hp"]
	mp = statsTotal["mp"]
	randomize()
	calculateExperienceToNextLevel()
	updateExperienceBar()

func _physics_process(delta):
	handleMovement()
	handleRotation(delta)
	handleNegativeEffects(delta)

func update_bars():
	# hp
	$Healthbar.value = 100*hp/statsTotal["hp"]
	$CanvasLayer/InventoryParent/InventoryContainer/UIBars/UIHealthbar.value = 100*hp/statsTotal["hp"]
	# mp
	$Manabar.value = 100*mp/statsTotal["mp"]
	$CanvasLayer/InventoryParent/InventoryContainer/UIBars/UIManabar.value = 100*mp/statsTotal["mp"]

func _process(delta):
	if hp<=0:
		print("\nYou were defeated! Game restarted!")
		var _ignore = get_tree().reload_current_scene()
	else:
		hp=min(statsTotal["hp"], hp+(statsTotal["vit"]/10)*delta)
		mp=min(statsTotal["mp"], mp+(statsTotal["wis"]/10)*delta)
	handleRestarting()
	handleItemUse()
	handleAnimation()
	handleAbilityUse(delta)
	handleWeaponShooting(delta)
	update_bars()

var inventory = preload("res://Inventory.tres")
onready var cursor = get_node("CanvasLayer/Cursor")

func show_equipment_in_console():
	var stuff = {4: "weapon", 5: "ability", 6: "armor", 7: "ring"}
	for i in range(4,8):
		var napis = "empty"
		if inventory.items[i]:
			napis = inventory.items[i].name
		print(str("[",i,"] ", stuff[i],": ",napis))

func read_data_from_inventory():
	#show_equipment_in_console()
	setWeapon(inventory.items[4])
	setAbility(inventory.items[5])
	setArmor(inventory.items[6])
	setRing(inventory.items[7])
	cursor.texture = null
	recalculateItemStatBonuses()
	recalculateTotalStats()
	

func handleItemUse():
	for i in range(1, 9):
		if Input.is_action_just_pressed(str(i)):
			var slot
			if i<=4:
				slot = i-1
				#print(slot)
			if i>4 and i<12:
				slot = i+3
				#print(slot)
			if inventory.items[slot]:
				#print(str("Trying to use item: ", inventory.items[slot].name))
				if inventory.items[slot].itemType == "weapon":
					print("That's a weapon!")
					inventory.swap_items(slot, 4)
					read_data_from_inventory()
				elif inventory.items[slot].itemType == "ability":
					print("That's an ability!")
					inventory.swap_items(slot, 5)
					read_data_from_inventory()
				elif inventory.items[slot].itemType == "armor":
					print("That's an armor!")
					inventory.swap_items(slot, 6)
					read_data_from_inventory()
				elif inventory.items[slot].itemType == "ring":
					print("That's a ring!")
					inventory.swap_items(slot, 7)
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
		print(str("Took ",damageToDeal," armor-ignoring damage from ", enemyName, "'s ",enemyAttackName,"!"))
		spawnDamageFloatingText2(damageToDeal, true)
	else:
		damageToDeal = max(damage-statsTotal["def"], damage*minimalTakenDamageMultiplier)
		print(str("Took ",damageToDeal," (",damage,") damage from ", enemyName, "'s ",enemyAttackName,"!"))
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
		var _ignore = move_and_slide(movement.rotated(rotation))


func handleRotation(delta):
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0


func handleAnimation():
	if Input.is_action_pressed("Down"):
		sprite_node.texture=textureDown
	elif Input.is_action_pressed("Up"):
		sprite_node.texture = textureUp
	elif Input.is_action_pressed("Right"):
		sprite_node.texture = textureRight
	elif Input.is_action_pressed("Left"):
		sprite_node.texture = textureLeft

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
		get_parent().add_child(new_arrow)

func handleAbilityUse(delta):
	if remaining_ability_cooldown > 0:
		remaining_ability_cooldown -= delta
		return
	if not Input.is_action_just_pressed("Ability"):
		return
	if not inventory.items[5]:
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

func handleWeaponShooting(delta):
	if Input.is_action_just_pressed("i"):
		autofire = !autofire
	if remaining_weapon_cooldown > 0:
		remaining_weapon_cooldown -= delta
		return
	if (not autofire and not Input.is_action_pressed("Shoot")):
		return
	if not inventory.items[4]:
		spawnFloatingTextMessage("no weapon equipped!")
		return
	remaining_weapon_cooldown = 1.0/usedWeapon.rateOfFire*10.0/statsTotal["dex"]
	generateBullets(usedWeapon, get_global_position())
