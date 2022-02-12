extends "res://Enemy.gd"

func _physics_process(delta):
	basicEnemyMovement(delta)

func _process(delta):
	enemyProcess(delta)
	for i in range(weapons.size()):
		basicEnemyShooting(delta, weapons[i], i)
	for i in range(bombs.size()):
		basicEnemyBombing(delta, bombs[i], i)
