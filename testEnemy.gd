extends KinematicBody2D

var maxhp = 500.0
var hp = maxhp

func _ready():
	$EnemyHealthbar.value = 100*hp/maxhp

func _process(delta):
	if hp<=0:
		print("Enemy defeated!")
		queue_free()

func takeDamage(damage):
	hp -= damage
	$EnemyHealthbar.value = 100*hp/maxhp
