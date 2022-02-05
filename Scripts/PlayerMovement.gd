extends KinematicBody2D

var speed = 60
var move_directon = Vector2(0, 0)

var can_fire = true
var invisibility = 0
var rotationSpeed = 90

var bulletSprites = {
	"arrow": preload("res://assets/bulletSprites/greenArrow.png"),
	"bows": {
		0: preload("res://assets/bulletSprites/bows/0.png"),
		1: preload("res://assets/bulletSprites/bows/1.png"),
		2: preload("res://assets/bulletSprites/bows/2.png"),
		3: preload("res://assets/bulletSprites/bows/3.png"),
		4: preload("res://assets/bulletSprites/bows/4.png"),
		5: preload("res://assets/bulletSprites/bows/5.png"),
	},
	"swords": {
		0: preload("res://assets/bulletSprites/swords/0.png"),
		1: preload("res://assets/bulletSprites/swords/1.png"),
		2: preload("res://assets/bulletSprites/swords/2.png"),
		3: preload("res://assets/bulletSprites/swords/3.png"),
		4: preload("res://assets/bulletSprites/swords/4.png"),
		5: preload("res://assets/bulletSprites/swords/5.png"),
	},
	"sword": preload("res://assets/bulletSprites/swordBullet.png"),
}

var tieredWeaponsData = {
	"bow": {
		"att_spd": 3.0,
		"att_spd_gain": 2.0,
		"dmg_min": 20,
		"dmg_min_gain": 10,
		"dmg_max": 30,
		"dmg_max_gain": 15,
		"projectile_speed": 100,
		"lifetime": 0.5,
		"shots": 3,
		"angle": 30,
		"scalex": 0.5,
		"scaley": 0.5,
		"collisionShapeRadius": 2.5,
		#"collisionShapeHeight": 10,
		# fix?
		"collisionShapeHeight": 14,
		"spriteRotation": 0,
		"spriteOffsetX": 0.5,
		"spriteOffsetY": 0.5,
		"multihit": true,
	},
	"sword": {
		"att_spd": 3.0,
		"att_spd_gain": 1.0,
		"dmg_min": 30,
		"dmg_min_gain": 15,
		"dmg_max": 50,
		"dmg_max_gain": 30,
		"projectile_speed": 100,
		"lifetime": 0.3,
		"shots": 1,
		"angle": 0,
		"scalex": 0.8,
		"scaley": 0.8,
		"collisionShapeRadius": 1.5,
		#"collisionShapeHeight": 8,
		# fix?
		"collisionShapeHeight": 16,
		"spriteRotation": -45.0,
		"spriteOffsetX": 0.0,
		"spriteOffsetY": 0.0,
		"multihit": false,
	}
}

var weapons = {
	"def": {
		# balancing
		"att_spd": tieredWeaponsData["bow"].att_spd + tieredWeaponsData["bow"].att_spd_gain*0, "dmg_min": tieredWeaponsData["bow"].dmg_min + tieredWeaponsData["bow"].dmg_min_gain*0, "dmg_max": tieredWeaponsData["bow"].dmg_max + tieredWeaponsData["bow"].dmg_max_gain*0,
		# path
		"projectile_speed": tieredWeaponsData["bow"].projectile_speed, "lifetime": tieredWeaponsData["bow"].lifetime, "shots": tieredWeaponsData["bow"].shots, "angle": tieredWeaponsData["bow"].angle,
		# size & hitbox
		"scalex": tieredWeaponsData["bow"].scalex, "scaley": tieredWeaponsData["bow"].scaley, "collisionShapeRadius": tieredWeaponsData["bow"].collisionShapeRadius, "collisionShapeHeight": tieredWeaponsData["bow"].collisionShapeHeight, 
		# cosmetic
		"sprite": bulletSprites["arrow"], "modulate": Color(1, 1, 1),
		# properties
		"multihit": false, "armorPierce": false, "ignoreWalls": false,
		"spriteRotation": 0,
		"spriteOffsetX": 0.5,
		"spriteOffsetY": 0.5,
	},
	"sword_colossus": {
		"att_spd": 5.5,
		"projectile_speed": 50,
		"lifetime": 1.15,
		"shots": 1,
		"angle": 10,
		"scalex": 0.6,
		"scaley": 0.8,
		"sprite": bulletSprites["sword"],
		"collisionShapeRadius": 1.5,
		"collisionShapeHeight": 12,
		"modulate": Color(1, 1, 0),
	},
}

var usedWeapon = weapons["def"]

func _ready():
	randomize()
	for weapon in ["bow", "sword"]:
		for i in range(6):
			weapons[str(weapon,"_t",i)]={
				# balancing
				"att_spd": tieredWeaponsData[weapon].att_spd + tieredWeaponsData[weapon].att_spd_gain*i, "dmg_min": tieredWeaponsData[weapon].dmg_min + tieredWeaponsData[weapon].dmg_min_gain*i, "dmg_max": tieredWeaponsData[weapon].dmg_max + tieredWeaponsData[weapon].dmg_max_gain*i,
				# path
				"projectile_speed": tieredWeaponsData[weapon].projectile_speed, "lifetime": tieredWeaponsData[weapon].lifetime, "shots": tieredWeaponsData[weapon].shots, "angle": tieredWeaponsData[weapon].angle,
				# size & hitbox
				"scalex": tieredWeaponsData[weapon].scalex, "scaley": tieredWeaponsData[weapon].scaley, "collisionShapeRadius": tieredWeaponsData[weapon].collisionShapeRadius, "collisionShapeHeight": tieredWeaponsData[weapon].collisionShapeHeight, 
				# cosmetic
				"sprite": bulletSprites[str(weapon,"s")][i], "modulate": Color(1, 1, 1), "spriteRotation": tieredWeaponsData[weapon].spriteRotation, "spriteOffsetX": tieredWeaponsData[weapon].spriteOffsetX, "spriteOffsetY": tieredWeaponsData[weapon].spriteOffsetY,
				# properties
				"multihit": tieredWeaponsData[weapon].multihit, "armorPierce": false, "ignoreWalls": false,
				# data
				"type": weapon, "tier": i, "name": str(weapon,' t',i),
			}
	usedWeapon = weapons["bow_t0"]

func _physics_process(delta):
	handleMovement()
	handleRotation(delta)

func _process(delta):
	handleRestarting()
	handleWeaponChange()
	handleAnimation()
	handleShooting()

func handleRestarting():
	if Input.is_key_pressed(KEY_R):
		print("\nRestarted!")
		get_tree().reload_current_scene()

var type = "bow"
var tier = 0
var can_change_weapon = true

func handleWeaponChange():
	if Input.is_key_pressed(KEY_0):
		tier = 0
	elif Input.is_key_pressed(KEY_1):
		tier = 1
	elif Input.is_key_pressed(KEY_2):
		tier = 2
	elif Input.is_key_pressed(KEY_3):
		tier = 3
	elif Input.is_key_pressed(KEY_4):
		tier = 4
	elif Input.is_key_pressed(KEY_5):
		tier = 5
	if Input.is_key_pressed(KEY_TAB) and can_change_weapon:
		can_change_weapon = false
		if type == "bow":
			type = "sword"
		elif type == "sword":
			type = "bow"
		yield(get_tree().create_timer(0.5), "timeout")
		can_change_weapon = true
	usedWeapon = weapons[str(type, "_t", tier)]


var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")

var textureDown = preload("res://assets/playerSprites/archerGreen.png")
var textureUp = preload("res://assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func handleMovement():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*speed
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
			new_arrow.damage = rand_range(usedWeapon.dmg_min, usedWeapon.dmg_max)
			new_arrow.rotation = (get_angle_to(get_global_mouse_position())+PI/2+deg2rad((i-((usedWeapon.shots-1)/2))*((usedWeapon.angle)/(usedWeapon.shots))))+(rotation)
			new_arrow.get_child(1).texture = usedWeapon["sprite"]
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
		yield(get_tree().create_timer(1/usedWeapon.att_spd), "timeout")
		can_fire = true
