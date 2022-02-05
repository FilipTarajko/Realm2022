extends Node2D

var enemyPrefab = preload("res://prefabs/testEnemy.tscn")

var i = 0
var enemyCount = 0


var enemyBullet = preload("res://assets/bulletSprites/enemyBullets/0.png")

var enemiesData = {
	"enemy1": {
		"moveSpeed": 40,
		"escapeRange": 20,
		"visionRange": 300,
		"followRange": 30,
		"doesDodge": true,
		"modulate": Color(0, 1, 1),
		"scalex": 1.0,
		"scaley": 1.0,
		"maxHp": 100,
		"hpRegen": 10,
		"weapons": [
			{
				"att_spd": 1.0,
				"dmg_min": 20,
				"dmg_max": 30,
				"projectile_speed": 100,
				"lifetime": 0.5,
				"shots": 3,
				"angle": 30,
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
		"moveSpeed": 40,
		"escapeRange": 30,
		"visionRange": 300,
		"followRange": 40,
		"doesDodge": true,
		"modulate": Color(1, 0, 1),
		"scalex": 1.3,
		"scaley": 1.3,
		"maxHp": 300,
		"hpRegen": 30,
		"weapons": [],
	},
	"enemy3": {
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

func spawnEnemy(enemyData):
	for i in range(1):
		var new_enemy = enemyPrefab.instance()
		new_enemy.rotation = get_parent().get_node("Player").rotation
		new_enemy.position = get_global_position()
		new_enemy.moveSpeed = enemyData.moveSpeed
		new_enemy.escapeRange = enemyData.escapeRange
		new_enemy.visionRange = enemyData.visionRange
		new_enemy.followRange = enemyData.followRange
		new_enemy.doesDodge = enemyData.doesDodge
		new_enemy.scale.x = enemyData.scalex
		new_enemy.scale.y = enemyData.scaley
		new_enemy.defaultMaxHp = enemyData.maxHp
		new_enemy.hpRegen = enemyData.hpRegen
		new_enemy.weapons = enemyData.weapons.duplicate(true)
		new_enemy.get_node("Sprite").modulate = enemyData.modulate
		get_parent().add_child(new_enemy)
		enemyCount+=1

func _process(delta):
	if(Input.is_key_pressed(KEY_7)):
		i+=1
		spawnEnemy(enemiesData["enemy1"])

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	spawnEnemy(enemiesData["enemy1"])
	#for i in range(1):
	#	i+=1
	#	spawnEnemy(enemiesData[str("enemy",i%3+1)])
		
	while true:
	#	i+=1
	#	spawnEnemy(enemiesData[str("enemy",i%3+1)])
		print(str("spawned enemy ",enemyCount,"! FPS: ",Engine.get_frames_per_second()))
		yield(get_tree().create_timer(3.0), "timeout")
