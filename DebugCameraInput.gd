extends Camera2D

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		zoom.x += 0.001
		zoom.y += 0.001
	if Input.is_action_pressed("ui_up"):
		zoom.x -= 0.001
		zoom.y -= 0.001
