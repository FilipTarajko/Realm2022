extends KinematicBody2D

var maxhp = 500.0
var hp = maxhp

func _process(delta):
	$EnemyHealthbar.value = 100*hp/maxhp
	if hp<=0:
		print("Enemy defeated!")
		queue_free()
