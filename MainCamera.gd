extends Camera2D

var zoom_speed = 0.03
var ratio = 0.03125
var is_zooming = false
var is_dezooming = false
var current_layer_nb = 0
onready var current_layer = get_parent().get_parent()
var goal_zoom = 1
var goal_position = Vector2(0, 0)

func go_deeper():
	if is_dezooming:
		return
	var circuit = current_layer.get_node("Viewport/Layer" + str(current_layer_nb) + "Content/Circuit")
	circuit.emit_signal("set_active", false)
	is_zooming = true
	current_layer_nb += 1
	goal_zoom = pow(ratio, current_layer_nb)
	current_layer = current_layer.get_node("Viewport/Layer" + str(current_layer_nb)) as ViewportContainer
	goal_position.x = current_layer.rect_position.x + (current_layer.rect_size.x / 2)
	goal_position.y = current_layer.rect_position.y + (current_layer.rect_size.y / 2)

func go_higher():
	is_dezooming = true
	current_layer_nb -= 1
	goal_zoom = pow(ratio, current_layer_nb)
	current_layer = current_layer.get_parent().get_parent() as ViewportContainer
	goal_position.x = current_layer.rect_position.x + (current_layer.rect_size.x / 2)
	goal_position.y = current_layer.rect_position.y + (current_layer.rect_size.y / 2)
	var circuit = current_layer.get_node("Viewport/Layer" + str(current_layer_nb) + "Content/Circuit")
	print("Viewport/Layer" + str(current_layer_nb) + "Content/Circuit")
	circuit.emit_signal("set_active", true)

func _process(delta):
	if is_zooming:
		if zoom.x > goal_zoom or zoom.y > goal_zoom:
			zoom.x = lerp(zoom.x, goal_zoom - 0.001, zoom_speed)
			zoom.y = lerp(zoom.y, goal_zoom - 0.001, zoom_speed)
		else:
			zoom.x = goal_zoom
			zoom.y = goal_zoom
			is_zooming = false
			offset.x = goal_position.x
			offset.y = goal_position.y
		offset.x = lerp(offset.x, goal_position.x, 0.05)
		offset.y = lerp(offset.y, goal_position.y, 0.05)
	if is_dezooming:
		if zoom.x < goal_zoom or zoom.y < goal_zoom:
			zoom.x = lerp(zoom.x, goal_zoom + 0.001, zoom_speed)
			zoom.y = lerp(zoom.y, goal_zoom + 0.001, zoom_speed)
		else:
			zoom.x = goal_zoom
			zoom.y = goal_zoom
			is_dezooming = false
			offset.x = goal_position.x
			offset.y = goal_position.y
		offset.x = lerp(offset.x, goal_position.x, 0.05)
		offset.y = lerp(offset.y, goal_position.y, 0.05)
