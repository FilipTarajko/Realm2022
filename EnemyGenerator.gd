extends Node2D

var enemyPrefab = preload("res://prefabs/basicEnemy.tscn")

var enemiesSpawned = 0

func spawnEnemy(enemyData, x=get_global_position().x, y=get_global_position().y):
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
	enemiesSpawned+=1

func spawnEnemyCluster(enemyData, amount, spawnRange, x=get_global_position().x, y=get_global_position().y):
	for _i in range(amount):
		var spawnVector = Vector2(rand_range(0, spawnRange), 0).rotated(rand_range(0, 2*PI))
		spawnEnemy(enemyData, x+spawnVector.x, y+spawnVector.y)

func _ready():
	yield(get_tree(), "idle_frame")
	spawnEnemyCluster(load("res://Assets/Enemies/scorpion_1.tres"), 20, 24, 120, 40)
	spawnEnemyCluster(load("res://Assets/Enemies/scorpion_big.tres"), 1, 24, 120, 40)
	spawnEnemyCluster(load("res://Assets/Enemies/demon_red.tres"), 4, 24, 20, -200)
	spawnEnemyCluster(load("res://Assets/Enemies/demon_orange.tres"), 3, 24, -30, -220)

var frames = 0

func _show_data_each_x_seconds(seconds):
	frames+=1
	if not (frames % (144*seconds)):
		print(str("spawned enemies: ",enemiesSpawned,", FPS: ",Engine.get_frames_per_second()))

func _physics_process(_delta):
	pass
	#_show_data_each_x_seconds(5)
