extends Node2D

var pause_button_scene = load("res://entities/PauseButton.tscn")

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var mouse_position = get_global_mouse_position()
		if mouse_position.x > global_position.x - 14 * scale.x \
		and mouse_position.x < global_position.x + 14 * scale.x \
		and mouse_position.y > global_position.y - 14 * scale.y \
		and mouse_position.y < global_position.y + 14 * scale.y:
			var circuit = get_parent().get_node_or_null("Circuit")
			if circuit != null:
				circuit.has_started = true
				var timer = circuit.get_node_or_null("Timer") as Timer
				timer.start()
				var pause_button = pause_button_scene.instance()
				pause_button.position = position
				get_parent().add_child(pause_button)
				queue_free()
