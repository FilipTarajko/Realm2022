extends Camera2D

var zoomspeed=1

func _process(delta):
	align()
	if(Input.is_action_pressed("zoom_in")):
		if(zoom>Vector2(0.05,0.05)):
		#if(zoom>Vector2(-1.8,-1.8)):
			zoom=Vector2(zoom.x-zoomspeed*delta,zoom.y-zoomspeed*delta)
	if(Input.is_action_pressed("zoom_out")):
		if(zoom<Vector2(1.8,1.8)):
			zoom=Vector2(zoom.x+zoomspeed*delta,zoom.y+zoomspeed*delta)
