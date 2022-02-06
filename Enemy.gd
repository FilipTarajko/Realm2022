extends KinematicBody2D

var moveSpeed = 40
var escapeRange = 20
var visionRange = 300
var followRange = 50
var doesDodge = true
var defaultMaxHp = 1
var weapons = []
var maxHp
var hp
var enemyName
var hpRegen

onready var player = get_parent().get_node("Player")

var moveReset = true
var randomRunningAngle = rand_range(0,6.28)
var chaseRunningAngle = rand_range(-1,1)
var chaseRandomMaxAngle = 0
var moveTimer = Timer.new()


func _ready():
	maxHp = defaultMaxHp
	setStartingHealth()
	for weapon in weapons:
		weapon.can_fire = true
	moveTimer.set_one_shot(true)
	moveTimer.set_wait_time((0.2))
	moveTimer.connect("timeout",self,"move_timeout")
	add_child(moveTimer)

func setStartingHealth():
	hp = maxHp

func enemyProcess(delta):
	if hp<=0:
		print(str(enemyName, " defeated!"))
		queue_free()
	else:
		if hp<maxHp:
			hp=min(maxHp, hp+hpRegen*delta)
		$EnemyHealthbar.value = 100*hp/maxHp

func takeDamageSuper(damage):
	#print(str(enemyName, ": takeDamage"))
	#print(str(enemyName, " was dealt ",damage," damage!"))
	hp -= damage

func takeDamage(damage):
	takeDamageSuper(damage)

func move_timeout():
#	print("movetimeout")
	randomRunningAngle = rand_range(0,6.28)
	chaseRunningAngle = rand_range(-1,1)
	moveTimer.set_wait_time(rand_range(0.1,0.8))
	moveReset = true

var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")

func basicEnemyShooting(delta, usedWeapon):
	if global_position.distance_to(player.global_position)<usedWeapon.targetingRange and usedWeapon.can_fire == true:
		usedWeapon.can_fire = false
		var randomShootingAngle = rand_range(-usedWeapon.randomAngle, usedWeapon.randomAngle)/2.0
		for i in range(usedWeapon.shots):
			var new_arrow = arrowPrefab.instance()
			new_arrow.position = get_global_position()
			new_arrow.enemyName = enemyName
			new_arrow.collision_mask -= 12
			new_arrow.projectile_speed = usedWeapon.projectile_speed
			new_arrow.lifetime = usedWeapon.lifetime
			new_arrow.damage = rand_range(usedWeapon.dmg_min, usedWeapon.dmg_max)
			new_arrow.rotation = (get_angle_to(player.global_position)+PI/2+deg2rad((i-((usedWeapon.shots-1)/2))*((usedWeapon.angle)/(usedWeapon.shots))))+(rotation)+deg2rad(randomShootingAngle)
			new_arrow.get_child(1).texture = usedWeapon["sprite"]
			new_arrow.modulate = usedWeapon.modulate
			new_arrow.scale.x = usedWeapon.scalex
			new_arrow.scale.y = usedWeapon.scaley
			new_arrow.multihit = usedWeapon.multihit
			new_arrow.get_child(0).shape.radius = usedWeapon.collisionShapeRadius
			new_arrow.get_child(0).shape.height = usedWeapon.collisionShapeHeight
			new_arrow.get_child(1).rotation_degrees = usedWeapon.spriteRotation
			new_arrow.get_child(1).position.x = usedWeapon.spriteOffsetX
			new_arrow.get_child(1).position.y = usedWeapon.spriteOffsetY
			get_parent().add_child(new_arrow)
		yield(get_tree().create_timer(1/usedWeapon.att_spd), "timeout")
		usedWeapon.can_fire = true

func setSpriteSide(x):
	if(x>0):
		$Sprite.flip_h = false;
	elif(x<0):
		$Sprite.flip_h = true;

func basicEnemyMovement(delta):
	var vec_to_player = player.global_position - global_position
	var vec_to_move
	vec_to_player = vec_to_player.normalized()
	if(global_position.distance_to(player.global_position)<visionRange):
		if(global_position.distance_to(player.global_position)<escapeRange&&player.invisibility==0):
			vec_to_move = (-vec_to_player.rotated(chaseRunningAngle*deg2rad(chaseRandomMaxAngle)/2.0) * moveSpeed * delta)
			move_and_collide(vec_to_move)
			randomRunningAngle = rand_range(0,6.28)
			setSpriteSide(vec_to_move.x)
			#moveReset=false
		elif(global_position.distance_to(player.global_position)>followRange&&player.invisibility==0):
			vec_to_move = (vec_to_player.rotated(chaseRunningAngle*deg2rad(chaseRandomMaxAngle)/2.0) * moveSpeed * delta)
			move_and_collide(vec_to_move)
			randomRunningAngle = rand_range(0,6.28)
			setSpriteSide(vec_to_move.x)
			#moveReset=false
		else:
			if(doesDodge):
				move_and_collide((vec_to_player.rotated(randomRunningAngle)* moveSpeed * delta))
		if(moveReset==true):
			moveReset=false
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
