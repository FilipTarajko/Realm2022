extends Node2D

var enemyPrefab = preload("res://prefabs/testEnemy.tscn")

var i = 0
var enemyCount = 0

#func _ready():
#	maxhp = 300
#	enemyName = "testEnemy3434"
#	setStartingHealth()

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
	},
}

func spawnEnemy(enemyData):
	for i in range(1):
		var new_enemy = enemyPrefab.instance()
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
		new_enemy.get_node("Sprite").modulate = enemyData.modulate
		#new_enemy.get_node("Sprite").modulate = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
		get_parent().add_child(new_enemy)
		enemyCount+=1

func _process(delta):
	if(Input.is_key_pressed(KEY_7)):
		spawnEnemy(enemiesData["enemy1"])

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	for i in range(100):
		i+=1
		spawnEnemy(enemiesData[str("enemy",i%3+1)])
		
	while false:
		i+=1
		spawnEnemy(enemiesData[str("enemy",i%3+1)])
		#spawnEnemy(enemiesData["enemy1"])
		print(str("spawned enemy ",enemyCount,"! FPS: ",Engine.get_frames_per_second()))
		yield(get_tree().create_timer(10*i/5000.0), "timeout")
