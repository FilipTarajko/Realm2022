extends Label

var time = 0.33
var targetModulateR
var targetModulateG
var targetModulateB

func _process(delta):
	time-=delta
	if time <=0:
		queue_free()
	modulate = Color(targetModulateR, targetModulateG, targetModulateB, min(time*3, 1))
	#rect_position.y-=0.2
