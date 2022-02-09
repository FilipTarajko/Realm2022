extends Area2D

var projectile_speed = 100
var projectile_acceleration = 0
var lifetime = 0.1
var damage = 0
var movement = Vector2(projectile_speed, 0)
var multihit = false
var enemyName
var enemyAttackName
var slowDuration = 0
var paralyzeDuration = 0
var time = 0
var initialSpriteRotationSpeed = 0
var bulletWaveFrequency = 0
var bulletWaveAmplitude = 0
var rotateSpriteAndHitboxToMatchDirection = false
var defaultSpriteRotation = 0
var indexOfEnemysWeaponsBullet = 0
var startingSinusoidPoint = 0
var armorPierce = false

func calculateMovement():
	if not bulletWaveAmplitude:
		movement = Vector2(projectile_speed, 0).rotated(rotation-PI/2)
	else:
		calculateSinusoidalMovement()
func calculateSinusoidalMovement():
	var xAxisMovement = Vector2(projectile_speed, 0).rotated(rotation-PI/2)
	var yAxis = xAxisMovement.normalized().rotated(deg2rad(90)) 
	var yAxisMovement = yAxis*cos(time*bulletWaveFrequency*2*PI+startingSinusoidPoint)*(bulletWaveAmplitude*8.0)*(PI/4*bulletWaveFrequency)
	#print(yAxisMovement)
	movement = yAxisMovement+xAxisMovement
	if rotateSpriteAndHitboxToMatchDirection:
		$Sprite.rotation = deg2rad(defaultSpriteRotation)+movement.angle() - rotation + PI/2
		$CollisionShape2D.rotation = deg2rad(defaultSpriteRotation)+movement.angle() - rotation + PI/2

func _ready():
	calculateMovement()
	if indexOfEnemysWeaponsBullet%2:
		startingSinusoidPoint = PI
	position += movement.normalized()*($CollisionShape2D.shape.radius+$CollisionShape2D.shape.height/2)*scale.y

func _physics_process(delta):
	if initialSpriteRotationSpeed:
		$Sprite.rotation+=delta*deg2rad(initialSpriteRotationSpeed)
	handleMovement(delta)
	if projectile_acceleration or bulletWaveAmplitude:
		projectile_speed += delta*projectile_acceleration
		calculateMovement()
	time += delta
	if time > lifetime:
		queue_free()

func handleMovement(delta):
	position = position+(movement*8.0)*delta
	#move_and_slide(movement)
	#for i in get_slide_count():
	#	var collision = get_slide_collision(i)
	#	print("Arrow collided with ", collision.collider.name)
	#	if(collision.collider.name == "HighTerrain"):
	#		queue_free()

func _on_Arrow_body_entered(body):
	#print(str(body," entered"))
	if("hp" in body):
		if damage:
			if enemyName:
				body.takeDamage(damage, armorPierce, enemyName, enemyAttackName)
				if slowDuration:
					body.applySlow(slowDuration)
				if paralyzeDuration:
					body.applyParalyze(paralyzeDuration)
			else:
				body.takeDamage(damage, armorPierce)
				if slowDuration:
					body.applySlow(slowDuration)
				if paralyzeDuration:
					body.applyParalyze(paralyzeDuration)
		if not multihit:
			collision_layer = 0
			collision_mask = 0
			#damage = 0
			queue_free()
	else:
		#$Sprite.visible=false;
		queue_free()
