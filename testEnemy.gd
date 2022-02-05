extends "res://Enemy.gd"

var moveSpeed = 40
var escapeRange = 20
var visionRange = 300
var followRange = 50
var doesDodge = true
var defaultMaxHp = 1
var weapons = []

func _ready():
	maxHp = defaultMaxHp
	enemyName = "testEnemy3434"
	setStartingHealth()
	for weapon in weapons:
		weapon.can_fire = true

func _physics_process(delta):
	basicEnemyMovement(delta, moveSpeed, escapeRange, visionRange, followRange, doesDodge)

func _process(delta):
	enemyProcess(delta)
	for weapon in weapons:
		#print(str("trying to shoot ",weapon))
		basicEnemyShooting(delta, weapon, visionRange)

func takeDamage(damage):
	takeDamageSuper(damage)
