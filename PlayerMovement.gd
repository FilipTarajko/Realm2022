extends KinematicBody2D

var speed = 40
var move_directon = Vector2(0, 0)

func _physics_process(delta):
	MovementLoop()

func _process(delta):
	pass


func MovementLoop():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*speed
	# move_and_slide has delta built-in
	move_and_slide(movement)
