extends Node2D

var play_button_scene = load("res://entities/PlayButton.tscn")

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var maincamera = get_tree().get_root().get_child(0).get_node("Layer0/Viewport/Camera2D")
		var layer = maincamera.current_layer_nb
		var mouse_position = get_tree().get_root().get_mouse_position()
		if mouse_position.x > global_position.x - 14 * scale.x \
		and mouse_position.x < global_position.x + 14 * scale.x \
		and mouse_position.y > (global_position.y - (288 * layer)) - 14 * scale.y \
		and mouse_position.y < (global_position.y - (288 * layer)) + 14 * scale.y:
			var circuit = get_parent().get_node_or_null("Circuit")
			if circuit != null:
				var timer = circuit.get_node_or_null("Timer") as Timer
				timer.stop()
				var play_button = play_button_scene.instance()
				play_button.position = position
				get_parent().add_child(play_button)
				queue_free()
