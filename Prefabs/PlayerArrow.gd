extends Area2D

var projectile_speed = 100
var lifetime = 0.1
var damage = 0
var movement = Vector2(projectile_speed, 0)

func _ready():
	movement = Vector2(projectile_speed, 0).rotated(rotation-PI/2)
	position += movement.normalized()*8
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
		body.takeDamage(damage)
		print(str(body, " was dealt ",damage," damage!"))
	else:
		queue_free()
