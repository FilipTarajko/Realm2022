extends KinematicBody2D

var move_directon = Vector2(0, 0)

var can_fire = true
var invisibility = 0
var rotationSpeed = 90

var hp
var mana

# maxHp sets maxHp to maxHp
var baseMaxHp = 200.0
var itemMaxHp = 0.0
var totalMaxHp
# maxMana sets maxMana to maxMana
# NOT IMPLEMENTED
var baseMaxMana = 100.0
var itemMaxMana = 0.0
var totalMaxMana
# att multiplies damage by att/100
var baseAtt = 100.0
var itemAtt = 0.0
var totalAtt
# dex multiplies RoF by dex/10
var baseDex = 50.0
var itemDex = 0.0
var totalDex
# spd moves spd/10 tiles/s
var baseSpd = 75.0
var itemSpd = 0.0
var totalSpd
# vit regenerates vit/10 hp/s
var baseVit = 0.0
var itemVit = 0.0
var totalVit
# wis regenerates wis/10 mana/s
# NOT IMPLEMENTED
var baseWis = 50.0
var itemWis = 0.0
var totalWis
# def reduces damage from hit by def
var baseDef = 0.0
var itemDef = 0.0
var totalDef

func readItemStatBonuses():
	var calculatedItemMaxHp = 0
	var calculatedItemMaxMana = 0
	var calculatedItemAtt = 0
	var calculatedItemDex = 0
	var calculatedItemSpd = 0
	var calculatedItemVit = 0
	var calculatedItemWis = 0
	var calculatedItemDef = 0
	for i in range(4,8):
		if inventory.items[i]:
			calculatedItemMaxHp+=inventory.items[i].maxHp
			calculatedItemMaxMana+=inventory.items[i].maxMana
			calculatedItemAtt+=inventory.items[i].att
			calculatedItemDex+=inventory.items[i].dex
			calculatedItemSpd+=inventory.items[i].spd
			calculatedItemVit+=inventory.items[i].vit
			calculatedItemWis+=inventory.items[i].wis
			calculatedItemDef+=inventory.items[i].def
	itemMaxHp = calculatedItemMaxHp
	itemMaxMana = calculatedItemMaxMana
	itemAtt = calculatedItemAtt
	itemDex = calculatedItemDex
	itemSpd = calculatedItemSpd
	itemVit = calculatedItemVit
	itemWis = calculatedItemWis
	itemDef = calculatedItemDef
	totalMaxHp = baseMaxHp + itemMaxHp
	totalMaxMana = baseMaxMana + itemMaxMana
	totalAtt = baseAtt + itemAtt
	totalDex = baseDex + itemDex
	totalSpd = baseSpd + itemSpd
	totalVit = baseVit + itemVit
	totalWis = baseWis + itemWis
	totalDef = baseDef + itemDef
	if hp:
		if hp>totalMaxHp:
			hp = totalMaxHp
	if mana:
		if mana>totalMaxMana:
			mana = totalMaxMana

var minimalTakenDamageMultiplier = 0.1

var usedWeapon
var usedArmor
var usedRing

func setWeapon(weapon):
	usedWeapon = weapon

func setArmor(armor):
	usedArmor = armor

func setRing(ring):
	usedRing = ring

func _ready():
	read_data_from_inventory()
	readItemStatBonuses()
	hp = totalMaxHp
	randomize()

func _physics_process(delta):
	handleMovement()
	handleRotation(delta)

func _process(delta):
	if hp<=0:
		print("\nYou were defeated! Game restarted!")
		var _ignore = get_tree().reload_current_scene()
	else:
		if hp<totalMaxHp:
			hp=min(totalMaxHp, hp+(totalVit/10)*delta)
	$Healthbar.value = 100*hp/totalMaxHp
	handleRestarting()
	handleItemUse()
	handleAnimation()
	handleShooting()

var inventory = preload("res://Inventory.tres")
onready var cursor = get_node("CanvasLayer/Cursor")

func read_data_from_inventory():
	var stuff = {4: "weapon", 5: "ability", 6: "armor", 7: "ring"}
	for i in range(4,8):
		var napis = "empty"
		if inventory.items[i]:
			napis = inventory.items[i].name
		print(str("[",i,"] ", stuff[i],": ",napis))
	#if not inventory.items[4]:
		pass
	setWeapon(inventory.items[4])
	#if not inventory.items[6]:
	setArmor(inventory.items[6])
	#if not inventory.items[7]:
	setRing(inventory.items[7])
	cursor.texture = null
	readItemStatBonuses()

func handleItemUse():
	for i in range(1, 9):
		if Input.is_action_just_pressed(str(i)):
			var slot
			if i<=4:
				slot = i-1
				print(slot)
			if i>4:
				slot = i+3
				print(slot)
			if inventory.items[slot]:
				print(str("Trying to use item: ", inventory.items[slot].name))
				if inventory.items[slot].itemType == "weapon":
					print("That's a weapon!")
					inventory.swap_items(slot, 4)
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

func takeDamage(damage, enemyName):
	var damageToDeal = max(damage-totalDef, damage*minimalTakenDamageMultiplier)
	print(str("Took ",damageToDeal," (",damage,") damage from ", enemyName, "!"))
	hp-=damageToDeal

func handleRestarting():
	if Input.is_key_pressed(KEY_R):
		print("\nRestarted!")
		var _ignore = get_tree().reload_current_scene()


var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")

var textureDown = preload("res://assets/playerSprites/archerGreen.png")
var textureUp = preload("res://assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func handleMovement():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*totalSpd*0.8
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

func handleShooting():
	if not can_fire:
		return
	if not Input.is_action_pressed("Shoot"):
		return
	if not inventory.items[4]:
		#print("You do not have a weapon!")
		return
	can_fire = false
	for i in range(usedWeapon.shots):
		var new_arrow = arrowPrefab.instance()
		new_arrow.position = get_global_position()
		new_arrow.projectile_speed = usedWeapon.projectile_speed
		new_arrow.lifetime = usedWeapon.lifetime
		new_arrow.damage = rand_range(usedWeapon.dmg_min, usedWeapon.dmg_max)*totalAtt/100.0
		new_arrow.rotation = (get_angle_to(get_global_mouse_position())+PI/2+deg2rad((i-((usedWeapon.shots-1)/2))*((usedWeapon.angle)/(usedWeapon.shots))))+(rotation)
		new_arrow.get_child(1).texture = usedWeapon["bulletSprite"]
		new_arrow.modulate = usedWeapon.modulate
		new_arrow.scale.x = usedWeapon.scalex
		new_arrow.scale.y = usedWeapon.scaley
		if usedWeapon.ignoreWalls:
			new_arrow.collision_mask-=2
			new_arrow.get_node("Sprite").z_index+=2
		new_arrow.multihit = usedWeapon.multihit
		new_arrow.get_child(0).shape.radius = usedWeapon.collisionShapeRadius
		new_arrow.get_child(0).shape.height = usedWeapon.collisionShapeHeight
		new_arrow.get_child(1).rotation_degrees = usedWeapon.spriteRotation
		new_arrow.get_child(1).position.x = usedWeapon.spriteOffsetX
		new_arrow.get_child(1).position.y = usedWeapon.spriteOffsetY
		get_parent().add_child(new_arrow)
	yield(get_tree().create_timer(1.0/usedWeapon.rateOfFire*10.0/totalDex), "timeout")
	can_fire = true
