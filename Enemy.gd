extends KinematicBody2D

var maxhp
var hp
var enemyName

func setStartingHealth():
	hp = maxhp
	$EnemyHealthbar.value = 100*hp/maxhp

func enemyProcess():
	if hp<=0:
		print(str(enemyName, " defeated!"))
		queue_free()

func takeDamageSuper(damage):
	print(str(enemyName, ": takeDamage"))
	print(str(enemyName, " was dealt ",damage," damage!"))
	hp -= damage
	$EnemyHealthbar.value = 100*hp/maxhp
