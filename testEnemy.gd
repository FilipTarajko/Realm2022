extends "res://Enemy.gd"

var moveSpeed = 40
var escapeRange = 20
var visionRange = 300
var followRange = 50
var doesDodge = true
var defaultMaxHp = 1

func _ready():
	maxHp = defaultMaxHp
	enemyName = "testEnemy3434"
	setStartingHealth()

func _physics_process(delta):
	basicEnemyMovement(delta, moveSpeed, escapeRange, visionRange, followRange, doesDodge)

func _process(delta):
	enemyProcess(delta)

func takeDamage(damage):
	takeDamageSuper(damage)
