extends KinematicBody2D

var maxHp
var hp
var enemyName
var hpRegen


onready var player = get_parent().get_node("Player")

var moveReset = true
var randomAngle = rand_range(0,6.28)
var moveTimer = Timer.new()

func _ready():
	moveTimer.set_one_shot(true)
	moveTimer.set_wait_time((0.2))
	moveTimer.connect("timeout",self,"move_timeout")
	add_child(moveTimer)

func setStartingHealth():
	hp = maxHp
	$EnemyHealthbar.value = 100*hp/maxHp

func enemyProcess(delta):
	if hp<=0:
		print(str(enemyName, " defeated!"))
		queue_free()
	else:
		if hp<maxHp:
			hp=min(maxHp, hp+hpRegen*delta)

func takeDamageSuper(damage):
	print(str(enemyName, ": takeDamage"))
	print(str(enemyName, " was dealt ",damage," damage!"))
	hp -= damage
	$EnemyHealthbar.value = 100*hp/maxHp

func move_timeout():
#	print("movetimeout")
	randomAngle = rand_range(0,6.28)
	#print(randomAngle)
	moveTimer.set_wait_time(rand_range(0.1,0.8))
	moveReset = true
	

func basicEnemyMovement(delta, moveSpeed, escapeRange, visionRange, followRange, doesDodge):
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	if(global_position.distance_to(player.global_position)<visionRange):
		if(global_position.distance_to(player.global_position)<escapeRange&&player.invisibility==0):
			move_and_collide(-vec_to_player * moveSpeed * delta)
			randomAngle = rand_range(0,6.28)
			#moveReset=false
		elif(global_position.distance_to(player.global_position)>followRange&&player.invisibility==0):
			move_and_collide(vec_to_player * moveSpeed * delta)
			randomAngle = rand_range(0,6.28)
			#moveReset=false
		else:
			if(doesDodge):
				move_and_collide((vec_to_player.rotated(randomAngle)* moveSpeed * delta))
		if(moveReset==true):
			moveReset=false
			#print(randomAngle)
			moveTimer.start()
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=player.rotationSpeed*delta
		#$EnemyHealthbar.rotation_degrees=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=player.rotationSpeed*delta
		#$EnemyHealthbar.rotation_degrees=-player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0
		#$EnemyHealthbar.rotation_degrees=0
