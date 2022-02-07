extends Label

var time = 1
var targetModulateR
var targetModulateG
var targetModulateB

func _process(delta):
	time-=delta
	if time <=0:
		queue_free()
	modulate = Color(targetModulateR, targetModulateG, targetModulateB, min(time*2, 1))
