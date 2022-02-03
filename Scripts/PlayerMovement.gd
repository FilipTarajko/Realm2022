extends KinematicBody2D

var speed = 40
var move_directon = Vector2(0, 0)

func _physics_process(delta):
	HandleMovement()

func _process(delta):
	HandleAnimation()

var textureDown = preload("res://assets/playerSprites/archerGreen.png")
var textureUp = preload("res://assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func HandleMovement():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*speed
	# move_and_slide has delta built-in
	move_and_slide(movement)


func HandleAnimation():
	if Input.is_action_pressed("Down"):
		sprite_node.texture=textureDown
	elif Input.is_action_pressed("Up"):
		sprite_node.texture = textureUp
	elif Input.is_action_pressed("Right"):
		sprite_node.texture = textureRight
	elif Input.is_action_pressed("Left"):
		sprite_node.texture = textureLeft
