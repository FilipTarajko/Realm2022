extends Node2D

var items = []

func _ready():
	self.rotation = get_parent().get_node("Player").rotation

onready var player = get_parent().get_node("Player")

func check_for_deletion():
	var isEmpty = true
	for i in range(8):
		if items[i]:
			#print(str("contains ",items[i]))
			isEmpty = false
	if isEmpty:
		queue_free()

onready var textureRects = [
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/TextureRect"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/TextureRect2"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/TextureRect3"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer/TextureRect4"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/TextureRect"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/TextureRect2"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/TextureRect3"),
	get_node("NinePatchRect/VBoxContainer/HBoxContainer2/TextureRect4")
]

func _physics_process(delta):
	if get_global_mouse_position().distance_to(global_position) < 5:
		$NinePatchRect.visible = true
		for i in range(8):
			print(items[i])
			if items[i]:
				textureRects[i].visible = true
				textureRects[i].texture = items[i].itemSprite
			else:
				textureRects[i].visible = false
	else:
		$NinePatchRect.visible = false
	if Input.is_action_pressed("rotateLeft"):
		rotation_degrees-=player.rotationSpeed*delta
	if Input.is_action_pressed("rotateRight"):
		rotation_degrees+=player.rotationSpeed*delta
	if Input.is_action_just_pressed("resetRotation"):
		rotation_degrees=0
