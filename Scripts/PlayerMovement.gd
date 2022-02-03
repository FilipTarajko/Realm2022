extends KinematicBody2D

var speed = 40
var move_directon = Vector2(0, 0)

var can_fire = true

var bulletSprites = {
	"sword": preload("res://assets/bulletSprites/swordBullet.png"),
}

var weapons = {
	"bow": {
		0: {
			"att_spd": 3.5,
			"projectile_speed": 200,
			"lifetime": 0.25,
			"shots": 1,
			"angle": 0,
			"scalex": 0.5,
			"scaley": 0.5,
			"modulate": Color(1, 1, 1),
		},
		1: {
			"att_spd": 4.5,
			"projectile_speed": 250,
			"lifetime": 0.25,
			"shots": 2,
			"angle": 15,
			"scalex": 0.5,
			"scaley": 0.5,
			"modulate": Color(1, 0, 0),
		},
		2: {
			"att_spd": 5.5,
			"projectile_speed": 250,
			"lifetime": 0.28,
			"shots": 3,
			"angle": 30,
			"scalex": 0.5,
			"scaley": 0.5,
			"modulate": Color(0, 0, 0),
		},
		3: {
			"att_spd": 6.5,
			"projectile_speed": 250,
			"lifetime": 0.28,
			"shots": 5,
			"angle": 30,
			"scalex": 0.5,
			"scaley": 0.5,
			"modulate": Color(0, 0, 1),
		},
	},
	"sword": {
		0: {
			"att_spd": 3.5,
			"projectile_speed": 200,
			"lifetime": 0.15,
			"shots": 1,
			"angle": 0,
			"scalex": 0.4,
			"scaley": 0.8,
			"sprite": bulletSprites["sword"],
			"modulate": Color(1, 1, 1),
		},
		1: {
			"att_spd": 5.5,
			"projectile_speed": 250,
			"lifetime": 0.15,
			"shots": 2,
			"angle": 10,
			"scalex": 0.7,
			"scaley": 0.5,
			"sprite": bulletSprites["sword"],
			"modulate": Color(0, 0.5, 1),
		}
	}
}

var usedWeapon = weapons["sword"][1]

func _physics_process(delta):
	handleMovement()

func _process(delta):
	handleAnimation()
	handleShooting()


var arrowPrefab = preload("res://prefabs/PlayerArrow.tscn")

var textureDown = preload("res://assets/playerSprites/archerGreen.png")
var textureUp = preload("res://assets/playerSprites/archerGreenBack.png")
var textureLeft = preload("res://assets/playerSprites/archerGreenLeft.png")
var textureRight = preload("res://assets/playerSprites/archerGreenRight.png")

onready var sprite_node = get_node("Sprite")

func handleMovement():
	move_directon.x = int(Input.is_action_pressed("Right")) - int (Input.is_action_pressed("Left"))
	move_directon.y = int(Input.is_action_pressed("Down")) - int (Input.is_action_pressed("Up"))
	var movement = move_directon.normalized()*speed
	# move_and_slide has delta built-in
	move_and_slide(movement)


func handleAnimation():
	if Input.is_action_pressed("Down"):
		sprite_node.texture=textureDown
	elif Input.is_action_pressed("Up"):
		sprite_node.texture = textureUp
	elif Input.is_action_pressed("Right"):
		sprite_node.texture = textureRight
	elif Input.is_action_pressed("Left"):
		sprite_node.texture = textureLeft

func handleShooting():
	if Input.is_action_pressed("Shoot") and can_fire == true:
		can_fire = false
		for i in range(usedWeapon.shots):
			var new_arrow = arrowPrefab.instance()
			new_arrow.position = get_global_position()
			new_arrow.projectile_speed = usedWeapon.projectile_speed
			new_arrow.lifetime = usedWeapon.lifetime
			print(i)
			new_arrow.rotation = get_angle_to(get_global_mouse_position())+PI/2+deg2rad((i-((usedWeapon.shots-1)/2))*((usedWeapon.angle)/(usedWeapon.shots)))
			print("{%s}: {%s}" % [i, new_arrow.rotation])
			new_arrow.get_child(1).texture = usedWeapon["sprite"]
			new_arrow.modulate = usedWeapon.modulate
			new_arrow.scale.x = usedWeapon.scalex
			new_arrow.scale.y = usedWeapon.scaley
			get_parent().add_child(new_arrow)
		#print(Engine.get_frames_per_second())
		yield(get_tree().create_timer(1/usedWeapon.att_spd), "timeout")
		can_fire = true
