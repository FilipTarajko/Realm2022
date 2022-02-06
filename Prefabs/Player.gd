extends KinematicBody2D

var move_directon = Vector2(0, 0)

var can_fire = true
var invisibility = 0
var rotationSpeed = 90

var hp
var mana

# maxHp sets maxHp to maxHp
var maxHp = 200.0
# maxMana sets maxMana to maxMana
# NOT IMPLEMENTED
var maxMana = 100.0
# att multiplies damage by att/100
var att = 100.0
# dex multiplies RoF by dex/100
var dex = 100.0
# spd moves spd/10 tiles/s
var spd = 75.0
# vit regenerates vit/10 hp/s
var vit = 0.0
# wis regenerates wis/10 mana/s
# NOT IMPLEMENTED
var wis = 50.0
# def reduces damage from hit by def
var def = 40.0
var minimalTakenDamageMultiplier = 0.1

var usedWeapon

func setWeapon(weapon):
	usedWeapon=weapon


func _ready():
	hp = maxHp
	randomize()

func _physics_process(delta):
	handleMovement()
	handleRotation(delta)

func _process(delta):
	if hp<=0:
		print("\nYou were defeated! Game restarted!")
		get_tree().reload_current_scene()
	else:
		if hp<maxHp:
			hp=min(maxHp, hp+(vit/10)*delta)
	$Healthbar.value = 100*hp/maxHp
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
	if not inventory.items[4]:
		inventory.set_item(4, load("res://Assets/Items/bow_t0.tres"))
	setWeapon(inventory.items[4])
	cursor.texture = null

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
			else:
				print("You are trying to use empty inventory slot!")

func takeDamage(damage, enemyName):
	var damageToDeal = max(damage-def, damage*minimalTakenDamageMultiplier)
	print(str("Took ",damageToDeal," (",damage,") damage from ", enemyName, "!"))
	hp-=damageToDeal

func handleRestarting():
	if Input.is_key_pressed(KEY_R):
		print("\nRestarted!")
		get_tree().reload_current_scene()


var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")

var textureDown = preload("res://assets/playerSprites/archerGreen.png")
var textureUp = preload("res://assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func handleMovement():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*spd*0.8
	# move_and_slide has delta built-in
	move_and_slide(movement.rotated(rotation))


func handleRotation(delta):
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=rotationSpeed*delta
		#$EnemyHealthbar.rotation_degrees=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=rotationSpeed*delta
		#$EnemyHealthbar.rotation_degrees=-player.rotationSpeed*delta
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
	if Input.is_action_pressed("Shoot") and can_fire == true:
		can_fire = false
		for i in range(usedWeapon.shots):
			var new_arrow = arrowPrefab.instance()
			new_arrow.position = get_global_position()
			new_arrow.projectile_speed = usedWeapon.projectile_speed
			new_arrow.lifetime = usedWeapon.lifetime
			new_arrow.damage = rand_range(usedWeapon.dmg_min, usedWeapon.dmg_max)*att/100.0
			new_arrow.rotation = (get_angle_to(get_global_mouse_position())+PI/2+deg2rad((i-((usedWeapon.shots-1)/2))*((usedWeapon.angle)/(usedWeapon.shots))))+(rotation)
			new_arrow.get_child(1).texture = usedWeapon["bulletSprite"]
			new_arrow.modulate = usedWeapon.modulate
			new_arrow.scale.x = usedWeapon.scalex
			new_arrow.scale.y = usedWeapon.scaley
			new_arrow.multihit = usedWeapon.multihit
			new_arrow.get_child(0).shape.radius = usedWeapon.collisionShapeRadius
			new_arrow.get_child(0).shape.height = usedWeapon.collisionShapeHeight
			new_arrow.get_child(1).rotation_degrees = usedWeapon.spriteRotation
			new_arrow.get_child(1).position.x = usedWeapon.spriteOffsetX
			new_arrow.get_child(1).position.y = usedWeapon.spriteOffsetY
			get_parent().add_child(new_arrow)
		yield(get_tree().create_timer(100.0/usedWeapon.att_spd/dex), "timeout")
		can_fire = true
