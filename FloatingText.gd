extends Position2D

var velocity = Vector2(0, -0.0)
var force = Vector2(0, -0.0)
var time = 0
var startColor = Color(1, 0, 0, 1)

func _ready():
	$DamageLabel.modulate = startColor
	$FloatingTextTween.interpolate_property(self, "modulate", modulate,
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.8, Tween.TRANS_LINEAR, 0.8)
	$FloatingTextTween.start()

func _process(delta):
	if time>=0.4:
		velocity+=force*delta
	position+=velocity*delta
	time+=delta
	if time>=1.6:
		queue_free()
