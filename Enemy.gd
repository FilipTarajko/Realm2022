extends KinematicBody2D

var moveSpeed = 40
var escapeRange = 20
var visionRange = 300
var followRange = 50
var doesDodge = true
var defaultMaxHp = 1
var weapons = []
var bombs = []
var maxHp
var def
var hp
var enemyName
var hpRegen
var remaining_weapon_cooldown = []
var remaining_bomb_cooldown = []
var weapon_bullets_shot = []
var floatingDamages = []
var floatingDamagesWeakrefs = []
var isUsing16pxSprite = false
var experienceReward

onready var player = get_parent().get_node("Player")
var floatingDamage = load("res://EnemyFloatingDamage.tscn")

var moveReset = true
var randomRunningAngle = rand_range(0,6.28)
var chaseRunningAngle = rand_range(-1,1)
var chaseRandomMaxAngle = 0
var moveTimer = Timer.new()

var minimalTakenDamageMultiplier = 0.15

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

onready var SpriteNode = get_node("Graphical").get_node("Sprite")
onready var HealthbarNode = get_node("Graphical").get_node("EnemyHealthbar")

func _ready():
	maxHp = defaultMaxHp
	setStartingHealth()
	for weapon in weapons:
		remaining_weapon_cooldown.append(0)
		weapon_bullets_shot.append(0)
	for bomb in bombs:
		remaining_bomb_cooldown.append(0)
	moveTimer.set_one_shot(true)
	moveTimer.set_wait_time((0.2))
	moveTimer.connect("timeout",self,"move_timeout")
	add_child(moveTimer)
	if isUsing16pxSprite:
		SpriteNode.position.y -= 4
	#	print("przesunalem o 4")
	if not experienceReward:
		experienceReward = maxHp

func setStartingHealth():
	hp = maxHp

func enemyProcess(delta):
	if hp<maxHp:
		hp=min(maxHp, hp+hpRegen*delta)
	HealthbarNode.value = 100*hp/maxHp
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

func spawnDamageFloatingText2(damage, ignoringArmor):
	var newFloatingDamage = floatingDamage2.instance()
	newFloatingDamage.get_node("DamageLabel").text=str(round(damage))
	if ignoringArmor:
		newFloatingDamage.startColor = Color(1, rand_range(0.6, 1.0), rand_range(0.8, 1.0), 1)
	else:
		newFloatingDamage.startColor = Color(1, rand_range(0.6, 1.0), rand_range(0.0, 0.2), 1)
	var startingY = -10
	if isUsing16pxSprite:
		startingY -= 8
	startingY *= scale.y
	startingY -= rand_range(0, 10)
	newFloatingDamage.position = position + Vector2(rand_range(-3, 3), startingY) #global_position #- Vector2(20 + rand_range(-5, 5), 30 + rand_range(-2, 6))
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

func takeDamage(damage, ignoringArmor):
	var damageToDeal
	if ignoringArmor:
		damageToDeal = damage
		spawnDamageFloatingText2(damageToDeal, true)
	else:
#		damageToDeal = max(damage-def, damage*(1.0-minimalTakenDamageMultiplier))
		damageToDeal = max(damage-def, damage*minimalTakenDamageMultiplier)
		spawnDamageFloatingText2(damageToDeal, false)
	hp -= damageToDeal
	if hp<=0:
		die()


var lootbag = preload("res://Prefabs/lootbag.tscn")

func die():
	print(str(enemyName, " defeated!"))
	collision_layer = 0
	collision_mask = 0
	player.gainExperience(experienceReward)
	var newLootbag = lootbag.instance()
	newLootbag.global_position = global_position
	get_parent().add_child(newLootbag)
	queue_free()


func move_timeout():
#	print("movetimeout")
	randomRunningAngle = rand_range(0,6.28)
	chaseRunningAngle = rand_range(-1,1)
	moveTimer.set_wait_time(rand_range(0.1,0.8))
	moveReset = true

var arrowPrefab = preload("res://Prefabs/PlayerArrow.tscn")
var bombPrefab = preload("res://Prefabs/bombPrefab.tscn")


func generateBombs(shootingWeapon, weaponIndex, position, isSpawnedByEnemy = true, targetPosition = player.position):
	var new_bomb = bombPrefab.instance()
	new_bomb.position = targetPosition
	new_bomb.rotation = get_parent().get_node("Player").rotation
	new_bomb.enemyAttackName = shootingWeapon.enemyWeaponName
	new_bomb.dmg = shootingWeapon.dmg
	new_bomb.armorPierce = shootingWeapon.armorPierce
	new_bomb.slowDuration = shootingWeapon.slowDuration
	new_bomb.paralyzeDuration = shootingWeapon.paralyzeDuration
	new_bomb.fallingTime = shootingWeapon.flightTimeBase
	new_bomb.impactRadius = shootingWeapon.impactRadius
	new_bomb.enemyName = enemyName
	if shootingWeapon.flightTimePerTile:
		new_bomb.fallingTime += shootingWeapon.flightTimePerTile * global_position.distance_to(player.global_position)
	get_parent().add_child(new_bomb)

func generateBullets(shootingWeapon, weaponIndex, position, isSpawnedByEnemy, targetAngle):
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
		new_arrow.rotation += deg2rad(rand_range(-shootingWeapon.eachBulletRandomAngleDiff/2, shootingWeapon.eachBulletRandomAngleDiff/2))
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
		new_arrow.initialSpriteRotationSpeed = shootingWeapon.initialSpriteRotationSpeed
		new_arrow.get_child(0).shape.height = shootingWeapon.collisionShapeHeight
		new_arrow.get_child(1).rotation_degrees = shootingWeapon.spriteRotation
		new_arrow.get_child(1).position.x = shootingWeapon.spriteOffsetX
		new_arrow.get_child(1).position.y = shootingWeapon.spriteOffsetY
		new_arrow.armorPierce = shootingWeapon.armorPierce
		new_arrow.bulletWaveFrequency = shootingWeapon.bulletWaveFrequency
		new_arrow.bulletWaveAmplitude = shootingWeapon.bulletWaveAmplitude
		new_arrow.rotateSpriteAndHitboxToMatchDirection = shootingWeapon.rotateSpriteAndHitboxToMatchDirection
		new_arrow.defaultSpriteRotation = shootingWeapon.spriteRotation
		new_arrow.indexOfEnemysWeaponsBullet = weapon_bullets_shot[weaponIndex]
		if shootingWeapon.followsEnemy:
			new_arrow.position -= global_position
			add_child(new_arrow)
		else:
			get_parent().add_child(new_arrow)
		weapon_bullets_shot[weaponIndex]+=1
		#print(weapon_bullets_shot[weaponIndex])


func shootNextTentacleShotAfterDelay(usedWeapon, weaponIndex, angle, shotsLeft, seconds):
	var t = Timer.new()
	t.set_wait_time(seconds)
	t.set_one_shot(true)
	self.add_child(t)
	if shotsLeft > 1:
		t.connect("timeout", self, "shootNextTentacleShotAfterDelay", [usedWeapon, weaponIndex, angle+deg2rad(usedWeapon.burstsAngleDiff), shotsLeft-1, seconds])
		t.start()
	generateBullets(usedWeapon, weaponIndex, get_global_position(), true, angle)


func TimerTimeout():
	print("timeout!")

func basicEnemyBombing(delta, usedBomb, i):
	if remaining_bomb_cooldown[i]>0:
		remaining_bomb_cooldown[i] = max(remaining_bomb_cooldown[i]-delta, 0)
	if global_position.distance_to(player.global_position)<usedBomb.targetingRange*8.0 and remaining_bomb_cooldown[i] <= 0:
		remaining_bomb_cooldown[i] = usedBomb.attackPeriod
		if usedBomb.bursts == 1:
			generateBombs(usedBomb, i, get_global_position(), true, player.global_position)
		else:
			pass
#			shootNextTentacleShotAfterDelay(usedBomb, i, targetAngle, usedBomb.bursts, usedBomb.burstsDelay)

func basicEnemyShooting(delta, usedWeapon, i):
	if remaining_weapon_cooldown[i]>0:
		remaining_weapon_cooldown[i] = max(remaining_weapon_cooldown[i]-delta, 0)
	if global_position.distance_to(player.global_position)<usedWeapon.targetingRange*8.0 and remaining_weapon_cooldown[i] <= 0:
		remaining_weapon_cooldown[i] = usedWeapon.attackPeriod
		var randomShootingAngle = rand_range(-usedWeapon.randomAngle, usedWeapon.randomAngle)/2.0
		var playerAngle = (get_angle_to(player.global_position)+PI/2)+(rotation)
		var targetAngle = playerAngle+deg2rad(randomShootingAngle)
		if usedWeapon.bursts == 1:
			generateBullets(usedWeapon, i, get_global_position(), true, targetAngle)
		else:
			shootNextTentacleShotAfterDelay(usedWeapon, i, targetAngle, usedWeapon.bursts, usedWeapon.burstsDelay)


func setSpriteSide(x):
	if(x>0):
		SpriteNode.flip_h = false;
	elif(x<0):
		SpriteNode.flip_h = true;


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
		$Graphical.rotation_degrees-=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		$Graphical.rotation_degrees+=player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		$Graphical.rotation_degrees=0
		
