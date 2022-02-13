extends Position2D

var velocity = Vector2(0, -0.0)
var force = Vector2(0, -0.0)
var time = 0
var startColor = Color(1, 0, 0, 1)
var alphaEndTime = 0.8
var alphaStartTime = 0.0
var isOnPlayer = true
var player

func _ready():
	$DamageLabel.modulate = startColor
	$FloatingTextTween.interpolate_property(self, "modulate", modulate,
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		alphaEndTime, Tween.TRANS_LINEAR, Tween.EASE_IN, alphaStartTime)
	$FloatingTextTween.start()

func _process(delta):
	if time>=0.2:
		velocity+=force*delta
	position+=velocity*delta
	time+=delta
	if time>=alphaEndTime+alphaStartTime:
		queue_free()
	if not isOnPlayer:
		if Input.is_action_pressed("rotateLeft"):
			rotation_degrees-=player.rotationSpeed*delta
		if Input.is_action_pressed("rotateRight"):
			rotation_degrees+=player.rotationSpeed*delta
		if Input.is_action_just_pressed("resetRotation"):
			rotation_degrees=0
