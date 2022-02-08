extends Area2D

var projectile_speed = 100
var lifetime = 0.1
var damage = 0
var movement = Vector2(projectile_speed, 0)
var multihit = false
var enemyName
var enemyAttackName
var slowDuration = 0
var paralyzeDuration = 0

func _ready():
	movement = Vector2(projectile_speed, 0).rotated(rotation-PI/2)*8.0
	position += movement.normalized()*($CollisionShape2D.shape.radius+$CollisionShape2D.shape.height/2)*scale.y
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()

func _physics_process(delta):
	handleMovement(delta)

func handleMovement(delta):
	position = position+(movement)*delta
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
				body.takeDamage(damage, enemyName, enemyAttackName)
				if slowDuration:
					body.applySlow(slowDuration)
				if paralyzeDuration:
					body.applyParalyze(paralyzeDuration)
			else:
				body.takeDamage(damage)
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
