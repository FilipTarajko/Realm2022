extends "res://Enemy.gd"

func _physics_process(delta):
	basicEnemyMovement(delta)

func _process(delta):
	enemyProcess(delta)
	for weapon in weapons:
		basicEnemyShooting(delta, weapon)
