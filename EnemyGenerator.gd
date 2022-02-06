extends Node2D

var enemyPrefab = preload("res://prefabs/basicEnemy.tscn")

var i = 0
var enemyCount = 0

var testEnemySprite = preload("res://assets/enemySprites/enemyWhite.png")
var scorpionSprite = preload("res://assets/enemySprites/scorpion.png")
var demonSprite = preload("res://assets/enemySprites/demon.png")

var enemyBullet = preload("res://assets/bulletSprites/enemyBullets/0.png")
var scorpionBullet = preload("res://assets/bulletSprites/enemyBullets/scorpionBullet.png")
var demonBullet = preload("res://assets/bulletSprites/enemyBullets/demonBullet.png")


var enemiesData = {
	"scorpion_1": {
		"enemyName": "tiny scorpion",
		"sprite": scorpionSprite,
		"moveSpeed": 10,
		"escapeRange": 0,
		"visionRange": 100,
		"followRange": 0,
		"doesDodge": false,
		"chaseRandomMaxAngle": 30,
		"modulate": Color(1, 1, 0),
		"scalex": 0.8,
		"scaley": 0.8,
		"maxHp": 40,
		"shadowSizeMultiplier": 1,
		"hpRegen": 1,
		"weapons": [
			{
				"att_spd": 0.3,
				"dmg_min": 3,
				"dmg_max": 5,
				"projectile_speed": 50,
				"lifetime": 0.7,
				"shots": 1,
				"angle": 0,
				"targetingRange": 80,
				"randomAngle": 30,
				"scalex": 0.4,
				"scaley": 0.4,
				"collisionShapeRadius": 2.5,
				"collisionShapeHeight": 14,
				"spriteRotation": 0,
				"spriteOffsetX": 0.5,
				"spriteOffsetY": 0.5,
				"multihit": false,
				"sprite": scorpionBullet,
				"modulate": Color(0.5, 0.2, 0.2),
			}
		]
	},
	"demon_red": {
		"enemyName": "red demon",
		"sprite": demonSprite,
		"moveSpeed": 30,
		"escapeRange": 20,
		"visionRange": 100,
		"followRange": 70,
		"doesDodge": true,
		"chaseRandomMaxAngle": 90,
		"modulate": Color(1, 0, 0),
		"scalex": 1.0,
		"scaley": 1.0,
		"maxHp": 500,
		"shadowSizeMultiplier": 0.7,
		"hpRegen": 1,
		"weapons": [
			{
				"att_spd": 0.6,
				"dmg_min": 25,
				"dmg_max": 30,
				"projectile_speed": 50,
				"lifetime": 1.8,
				"shots": 3,
				"angle": 60,
				"targetingRange": 80,
				"randomAngle": 30,
				"scalex": 0.7,
				"scaley": 0.7,
				"collisionShapeRadius": 2.5,
				"collisionShapeHeight": 14,
				"spriteRotation": 0,
				"spriteOffsetX": 0.5,
				"spriteOffsetY": 0.5,
				"multihit": false,
				"sprite": demonBullet,
				"modulate": Color(1.0, 0.0, 0.0),
			}
		]
	},
	"demon_orange": {
		"enemyName": "orange demon",
		"sprite": demonSprite,
		"moveSpeed": 20,
		"escapeRange": 60,
		"visionRange": 150,
		"followRange": 120,
		"doesDodge": true,
		"chaseRandomMaxAngle": 90,
		"modulate": Color(1, 0.3, 0),
		"scalex": 1.0,
		"scaley": 1.0,
		"maxHp": 300,
		"shadowSizeMultiplier": 0.7,
		"hpRegen": 1,
		"weapons": [
			{
				"att_spd": 0.4,
				"dmg_min": 45,
				"dmg_max": 50,
				"projectile_speed": 50,
				"lifetime": 3.0,
				"shots": 3,
				"angle": 60,
				"targetingRange": 135,
				"randomAngle": 10,
				"scalex": 0.9,
				"scaley": 0.9,
				"collisionShapeRadius": 2.5,
				"collisionShapeHeight": 14,
				"spriteRotation": 0,
				"spriteOffsetX": 0.5,
				"spriteOffsetY": 0.5,
				"multihit": false,
				"sprite": demonBullet,
				"modulate": Color(1.0, 0.3, 0.0),
			}
		]
	},
	"enemy1": {
		"enemyName": "test enemy 1",
		"sprite": testEnemySprite,
		"moveSpeed": 40,
		"escapeRange": 20,
		"visionRange": 300,
		"followRange": 30,
		"doesDodge": true,
		"chaseRandomMaxAngle": 15,
		"modulate": Color(0, 1, 1),
		"scalex": 1.0,
		"scaley": 1.0,
		"maxHp": 100,
		"hpRegen": 10,
		"weapons": [
			{
				"att_spd": 1.0,
				"dmg_min": 2,
				"dmg_max": 3,
				"projectile_speed": 100,
				"lifetime": 0.5,
				"shots": 3,
				"angle": 30,
				"targetingRange": 100,
				"randomAngle": 15,
				"scalex": 0.5,
				"scaley": 0.5,
				"collisionShapeRadius": 2.5,
				"collisionShapeHeight": 14,
				"spriteRotation": 0,
				"spriteOffsetX": 0.5,
				"spriteOffsetY": 0.5,
				"multihit": false,
				"sprite": enemyBullet,
				"modulate": Color(1, 0, 0),
			}
		]
	},
	"enemy2": {
		"enemyName": "test enemy 2",
		"sprite": testEnemySprite,
		"moveSpeed": 40,
		"escapeRange": 20,
		"visionRange": 300,
		"followRange": 70,
		"doesDodge": true,
		"modulate": Color(1, 0, 1),
		"scalex": 1.3,
		"scaley": 1.3,
		"maxHp": 300,
		"hpRegen": 30,
		"weapons": [
			{
				"att_spd": 1.0,
				"dmg_min": 20,
				"dmg_max": 30,
				"projectile_speed": 150,
				"lifetime": 1.5,
				"shots": 1,
				"angle": 0,
				"scalex": 0.5,
				"scaley": 1.0,
				"collisionShapeRadius": 2.5,
				"collisionShapeHeight": 14,
				"spriteRotation": 0,
				"spriteOffsetX": 0.5,
				"spriteOffsetY": 0.5,
				"multihit": false,
				"sprite": enemyBullet,
				"modulate": Color(1, 0, 1),
			},
		],
	},
	"enemy3": {
		"enemyName": "test enemy 3",
		"sprite": testEnemySprite,
		"moveSpeed": 20,
		"escapeRange": 40,
		"visionRange": 300,
		"followRange": 50,
		"doesDodge": true,
		"modulate": Color(1, 1, 0),
		"scalex": 1.5,
		"scaley": 1.5,
		"maxHp": 500,
		"hpRegen": 100,
		"weapons": [],
	},
}

func spawnEnemy(enemyData, x=get_global_position().x, y=get_global_position().y):
	for i in range(1):
		var new_enemy = enemyPrefab.instance()
		new_enemy.get_node("Sprite").texture = enemyData.sprite
		new_enemy.rotation = get_parent().get_node("Player").rotation
		new_enemy.position = Vector2(x, y)
		new_enemy.enemyName = enemyData.enemyName
		new_enemy.moveSpeed = enemyData.moveSpeed
		new_enemy.escapeRange = enemyData.escapeRange
		new_enemy.visionRange = enemyData.visionRange
		new_enemy.followRange = enemyData.followRange
		new_enemy.doesDodge = enemyData.doesDodge
		new_enemy.chaseRandomMaxAngle = enemyData.chaseRandomMaxAngle
		new_enemy.scale.x = enemyData.scalex
		new_enemy.scale.y = enemyData.scaley
		new_enemy.defaultMaxHp = enemyData.maxHp
		new_enemy.hpRegen = enemyData.hpRegen
		new_enemy.get_node("Shadow").scale.x *= enemyData.shadowSizeMultiplier
		new_enemy.get_node("Shadow").scale.y *= enemyData.shadowSizeMultiplier
		new_enemy.get_node("CollisionShape2D").scale.x *= enemyData.shadowSizeMultiplier
		new_enemy.get_node("CollisionShape2D").scale.y *= enemyData.shadowSizeMultiplier
		new_enemy.get_node("Sprite").material.set_shader_param("width", 0.15/sqrt(enemyData.scalex*enemyData.scaley))
		new_enemy.weapons = enemyData.weapons.duplicate(true)
		new_enemy.get_node("Sprite").modulate = enemyData.modulate
		get_parent().add_child(new_enemy)
		enemyCount+=1

func spawnEnemyCluster(enemyData, amount, spawnRange, x=get_global_position().x, y=get_global_position().y):
	for i in range(amount):
		var spawnVector = Vector2(rand_range(0, spawnRange), 0).rotated(rand_range(0, 2*PI))
		spawnEnemy(enemyData, x+spawnVector.x, y+spawnVector.y)

func _process(delta):
	if(Input.is_key_pressed(KEY_7)):
		i+=1
		spawnEnemy(enemiesData["scorpion_1"])

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	spawnEnemyCluster(enemiesData["scorpion_1"], 20, 24, 120, 40)
	spawnEnemyCluster(enemiesData["demon_red"], 7, 24, 20, -200)
	spawnEnemyCluster(enemiesData["demon_orange"], 7, 24, -30, -220)
	#spawnEnemy(enemiesData["enemy1"], 20, -80)
	#spawnEnemy(enemiesData["enemy2"], 60, -80)
	#spawnEnemy(enemiesData["enemy2"], 80, -80)
	#spawnEnemy(enemiesData["enemy2"], 100, -80)
	#for i in range(1):
	#	i+=1
	#	spawnEnemy(enemiesData[str("enemy",i%3+1)])
		
	while true:
	#	i+=1
	#	spawnEnemy(enemiesData[str("enemy",i%3+1)])
		#print(str("spawned enemy ",enemyCount,"! FPS: ",Engine.get_frames_per_second()))
		yield(get_tree().create_timer(3.0), "timeout")
