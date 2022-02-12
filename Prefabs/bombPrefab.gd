extends Node2D

onready var player = get_parent().get_node("Player")

var impactRadius = 0.5*6
var color = Color(1, 0, 0)
var enemyAttackName
#var fallsFromAbove
var dmg
var armorPierce
var slowDuration
var paralyzeDuration
var fallingTime
var enemyName
var fallingSpeed = 3
var minRotationSpeed = 0.5
var maxRotationSpeed = 3


var impacted = false
var time = 0


func _ready():
	$FallingBomb.position.y = fallingSpeed * -8.0 * fallingTime
	$FallingBomb.process_material.gravity.y = fallingSpeed * -8.0 * 10
	# 0.97 TEMPORARY TEST
	$FallingBombMarker.process_material.emission_ring_radius = impactRadius*8*2*0.97
	$FallingBombMarker.process_material.emission_ring_inner_radius = impactRadius*8*2*0.97
	modulate = color
	scale.x *= impactRadius*2
	scale.y *= impactRadius*2
	print("falls from above not yet implemented!")


func boom():
	if (global_position.distance_to(player.global_position))<impactRadius*8+player.get_node("CollisionShape2D").shape.radius:
		if dmg:
			if enemyName:
				player.takeDamage(dmg, armorPierce, enemyName, enemyAttackName)
		if slowDuration:
			player.applySlow(slowDuration)
		if paralyzeDuration:
			player.applyParalyze(paralyzeDuration)


func _physics_process(delta):
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0


func _process(delta):
	time += delta
	if not impacted:
		var rotationSpeed = (minRotationSpeed+(maxRotationSpeed-minRotationSpeed)*(time/fallingTime))
		$FallingBombMarker.rotation+= rotationSpeed *delta
		$FallingBomb.position.y += fallingSpeed * 8.0 * delta
		if time>fallingTime:
			boom()
			impacted = true
			remove_child($FallingBomb)
#			remove_child($Sprite)
			remove_child($FallingBombMarker)
			$FallenBombParticles.emitting = true
			$FallenBombParticles.process_material.emission_ring_radius = impactRadius * 8 * 2
			$FallenBombParticles.restart()
	if time>fallingTime+1:
		queue_free()

#export(String) var enemyWeaponName = "bomb"
#export(bool) var fallsFromAbove = true
#export(float) var attackPeriod
#export(float) var dmg
#export(float) var flightTimePerTile = 0.0
#export(float) var flightTimeBase = 0.5
#export(float) var targetingRange = 10
#export(float) var impactRadius = 2.5
#export(bool) var armorPierce = false
#export(float) var slowDuration = 0
#export(float) var paralyzeDuration = 0
#export(float) var bursts = 1
#export(float) var burstsAngleDiff = 0
#export(float) var burstsDelay = 0
