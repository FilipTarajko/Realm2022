extends "res://Enemy.gd"

func _ready():
	maxhp = 300
	enemyName = "testEnemy3434"
	setStartingHealth()

func _process(delta):
	enemyProcess()

func takeDamage(damage):
	takeDamageSuper(damage)
