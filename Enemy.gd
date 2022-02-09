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
var remaining_weapon_cooldown = []
var floatingDamages = []
var floatingDamagesWeakrefs = []
var isUsing16pxSprite = false

onready var player = get_parent().get_node("Player")
var floatingDamage = load("res://EnemyFloatingDamage.tscn")

var moveReset = true
var randomRunningAngle = rand_range(0,6.28)
var chaseRunningAngle = rand_range(-1,1)
var chaseRandomMaxAngle = 0
var moveTimer = Timer.new()

### NEGATIVE EFFECTS ###

var slowed = 0.0
var slowMultiplier = 2.0
var paralyzed = 0.0

func applySlow(slowDuration):
	print("enemy slowed!")
	slowed = max(slowed, slowDuration)
	
func applyParalyze(paralyzeDuration):
	print("enemy paralyzed!")
	paralyzed = max(paralyzed, paralyzeDuration)

func handleNegativeEffects(delta):
	if slowed:
		slowed = max(slowed-delta, 0)
	if paralyzed:
		paralyzed = max(paralyzed-delta, 0)

###

func _ready():
	maxHp = defaultMaxHp
	setStartingHealth()
	for weapon in weapons:
		remaining_weapon_cooldown.append(0)
	moveTimer.set_one_shot(true)
	moveTimer.set_wait_time((0.2))
	moveTimer.connect("timeout",self,"move_timeout")
	add_child(moveTimer)
	if isUsing16pxSprite:
		$Sprite.position.y -= 4
	#	print("przesunalem o 4")

func setStartingHealth():
	hp = maxHp

func enemyProcess(delta):
	if hp<maxHp:
		hp=min(maxHp, hp+hpRegen*delta)
	$EnemyHealthbar.value = 100*hp/maxHp
	handleNegativeEffects(delta)

func moveFloatingDamagesToParent():
	for i in floatingDamagesWeakrefs.size():
		if(floatingDamagesWeakrefs[i].get_ref()):
			var previousScale = Vector2(floatingDamages[i].rect_scale.x*scale.x, floatingDamages[i].rect_scale.y*scale.y)
			remove_child(floatingDamages[i])
			get_parent().add_child(floatingDamages[i])
			floatingDamages[i].rect_position = global_position
			floatingDamages[i].rect_position += Vector2(((-12.5 + floatingDamages[i].random_offsets.x)*scale.x), (-7.25 - 9 *scale.y + floatingDamages[i].random_offsets.y)*scale.y)
			floatingDamages[i].rect_scale = previousScale


var floatingDamage2 = load("res://FloatingText.tscn")

func spawnFloatingText2(damage):
	var newFloatingDamage = floatingDamage2.instance()
	newFloatingDamage.get_node("DamageLabel").text=str(round(damage))
	newFloatingDamage.startColor = Color(1, rand_range(0.6, 1.0), rand_range(0.0, 0.6), 1)
	newFloatingDamage.position = position + Vector2(rand_range(-3, 3), rand_range(-5, 5)) #global_position #- Vector2(20 + rand_range(-5, 5), 30 + rand_range(-2, 6))
	#newFloatingDamage.rect_scale = Vector2(0.2, 0.2)
	get_parent().add_child(newFloatingDamage)
	#floatingDamages.append(newFloatingDamage)
	#floatingDamagesWeakrefs.append(weakref(newFloatingDamage))


func spawnFloatingText(damage):
	var newFloatingDamage = floatingDamage.instance()
	newFloatingDamage.text=str(round(damage))
	#newFloatingDamage.offset = Vector2(-12.5 + rand_range(-2, 2), -7.25 - 9 *scale.y + rand_range(-2, 2))
	newFloatingDamage.random_offsets = Vector2(rand_range(-2, 2), rand_range(-2, 2))
	newFloatingDamage.rect_position += Vector2(-12.5 + newFloatingDamage.random_offsets.x, -7.25 - 9 *scale.y + newFloatingDamage.random_offsets.y)
	newFloatingDamage.targetModulateR = 1.0
	newFloatingDamage.targetModulateG = 0.5
	newFloatingDamage.targetModulateB = 0.0
	#newFloatingDamage.following = self
	#newFloatingDamage.rect_scale = Vector2(0.2, 0.2)
	add_child(newFloatingDamage)
	floatingDamages.append(newFloatingDamage)
	floatingDamagesWeakrefs.append(weakref(newFloatingDamage))

func takeDamageSuper(damage):
	#print(str(enemyName, ": takeDamage"))
	#print(str(enemyName, " was dealt ",damage," damage!"))
	hp -= damage
	if hp<=0:
		print(str(enemyName, " defeated!"))
		#moveFloatingDamagesToParent()
		collision_layer = 0
		collision_mask = 0
		queue_free()
	spawnFloatingText2(damage)

func takeDamage(damage):
	print(str(enemyName, "took ",damage," damage!"))
	takeDamageSuper(damage)

func move_timeout():
#	print("movetimeout")
	randomRunningAngle = rand_range(0,6.28)
	chaseRunningAngle = rand_range(-1,1)
	moveTimer.set_wait_time(rand_range(0.1,0.8))
	moveReset = true

var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")


func generateBullets(shootingWeapon, position, isSpawnedByEnemy, targetAngle):
	for i in range(shootingWeapon.shots):
		var new_arrow = arrowPrefab.instance()
		new_arrow.position = position
		if isSpawnedByEnemy:
			new_arrow.collision_mask -= 12
			new_arrow.enemyName = enemyName
			new_arrow.enemyAttackName = shootingWeapon.enemyWeaponName
		new_arrow.projectile_speed = shootingWeapon.projectile_speed
		new_arrow.projectile_acceleration = shootingWeapon.projectile_acceleration
		new_arrow.lifetime = shootingWeapon.lifetime
		new_arrow.damage = rand_range(shootingWeapon.dmg_min, shootingWeapon.dmg_max)
		new_arrow.rotation = targetAngle + deg2rad((i-((shootingWeapon.shots-1)/2))*((shootingWeapon.angle)/(shootingWeapon.shots)))
		new_arrow.get_child(1).texture = shootingWeapon["sprite"]
		new_arrow.modulate = shootingWeapon.modulate
		new_arrow.scale.x = shootingWeapon.scalex
		new_arrow.scale.y = shootingWeapon.scaley
		if shootingWeapon.ignoreWalls:
			new_arrow.collision_mask-=2
			new_arrow.get_node("Sprite").z_index+=2
		new_arrow.multihit = shootingWeapon.multihit
		if "slowDuration" in shootingWeapon:
			new_arrow.slowDuration = shootingWeapon.slowDuration
		if "paralyzeDuration" in shootingWeapon:
			new_arrow.paralyzeDuration = shootingWeapon.paralyzeDuration
		new_arrow.get_child(0).shape.radius = shootingWeapon.collisionShapeRadius
		new_arrow.get_child(0).shape.height = shootingWeapon.collisionShapeHeight
		new_arrow.get_child(1).rotation_degrees = shootingWeapon.spriteRotation
		new_arrow.get_child(1).position.x = shootingWeapon.spriteOffsetX
		new_arrow.get_child(1).position.y = shootingWeapon.spriteOffsetY
		get_parent().add_child(new_arrow)


func shootNextTentacleShotAfterDelay(usedWeapon, angle, shotsLeft, seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	if shotsLeft > 1:
		t.connect("timeout", self, "shootNextTentacleShotAfterDelay", [usedWeapon, angle+deg2rad(usedWeapon.burstShotsAngleDiff), shotsLeft-1, seconds])
		t.start()
	generateBullets(usedWeapon, get_global_position(), true, angle)


func TimerTimeout():
	print("timeout!")


func basicEnemyShooting(delta, usedWeapon, i):
	if remaining_weapon_cooldown[i]>0:
		remaining_weapon_cooldown[i] = max(remaining_weapon_cooldown[i]-delta, 0)
	if global_position.distance_to(player.global_position)<usedWeapon.targetingRange*8.0 and remaining_weapon_cooldown[i] <= 0:
		remaining_weapon_cooldown[i] = 1/usedWeapon.att_spd
		var randomShootingAngle = rand_range(-usedWeapon.randomAngle, usedWeapon.randomAngle)/2.0
		var playerAngle = (get_angle_to(player.global_position)+PI/2)+(rotation)
		var targetAngle = playerAngle+deg2rad(randomShootingAngle)
		if usedWeapon.shotsInBurst == 1:
			generateBullets(usedWeapon, get_global_position(), true, targetAngle)
		else:
			shootNextTentacleShotAfterDelay(usedWeapon, targetAngle, usedWeapon.shotsInBurst, 0.1)


func setSpriteSide(x):
	if(x>0):
		$Sprite.flip_h = false;
	elif(x<0):
		$Sprite.flip_h = true;


func basicEnemyMovement(delta):
	var vec_to_player = player.global_position - global_position
	var vec_to_move
	var currentSpeed = moveSpeed
	if paralyzed:
		currentSpeed = 0
	elif slowed:
		currentSpeed /= slowMultiplier
	vec_to_player = vec_to_player.normalized()
	if(global_position.distance_to(player.global_position)<visionRange*8.0):
		if(global_position.distance_to(player.global_position)<escapeRange*8.0&&player.invisibility==0):
			vec_to_move = (-vec_to_player.rotated(chaseRunningAngle*deg2rad(chaseRandomMaxAngle)/2.0) * currentSpeed*8.0 * delta)
			var _ignore = move_and_collide(vec_to_move)
			randomRunningAngle = rand_range(0,6.28)
			setSpriteSide(vec_to_move.x)
			#moveReset=false
		elif(global_position.distance_to(player.global_position)>followRange*8.0&&player.invisibility==0):
			vec_to_move = (vec_to_player.rotated(chaseRunningAngle*deg2rad(chaseRandomMaxAngle)/2.0) * currentSpeed*8.0 * delta)
			var _ignore = move_and_collide(vec_to_move)
			randomRunningAngle = rand_range(0,6.28)
			setSpriteSide(vec_to_move.x)
			#moveReset=false
		else:
			if(doesDodge):
				var _ignore = move_and_collide((vec_to_player.rotated(randomRunningAngle)* currentSpeed*8.0 * delta))
		if(moveReset==true):
			moveReset=false
			moveTimer.start()
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0
