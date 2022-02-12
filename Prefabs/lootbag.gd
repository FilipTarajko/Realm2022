extends Node2D

var items = []

func _ready():
	self.rotation = get_parent().get_node("Player").rotation

onready var player = get_parent().get_node("Player")



func _physics_process(delta):
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0
