extends Camera2D

var zoom_speed = 5
var move_speed = 5
var ratio = 0.03125
var is_zooming = false
var is_dezooming = false
var current_layer_nb = 0
onready var current_layer = get_parent().get_parent()
onready var current_camera = self
var goal_zoom = 1
var goal_position = Vector2(0, 0)

func go_deeper():
	if is_dezooming:
		return
	var circuit = current_layer.get_node("Viewport/Layer" + str(current_layer_nb) + "Content/Circuit")
	circuit.emit_signal("set_active", false)
	is_zooming = true
	current_camera = current_layer.get_node("Viewport/Camera2D")
	current_layer_nb += 1
	current_layer = current_layer.get_node("Viewport/Layer" + str(current_layer_nb)) as ViewportContainer
	goal_position.x = current_layer.rect_position.x + (current_layer.rect_size.x / 2)
	goal_position.y = current_layer.rect_position.y + (current_layer.rect_size.y / 2)

func go_higher():
	is_dezooming = true
	current_layer_nb -= 1
	goal_position.x = 256
	goal_position.y = 144 + (288 * current_layer_nb)
	current_layer = current_layer.get_parent().get_parent() as ViewportContainer
	current_camera = current_layer.get_node("Viewport/Camera2D")
	var circuit = current_layer.get_node("Viewport/Layer" + str(current_layer_nb) + "Content/Circuit")
	circuit.emit_signal("set_active", true)

func _process(delta):
	if is_zooming:
		if current_camera.zoom.x > ratio or current_camera.zoom.y > ratio:
			current_camera.zoom.x = lerp(current_camera.zoom.x, ratio - 0.001, zoom_speed * delta)
			current_camera.zoom.y = lerp(current_camera.zoom.y, ratio - 0.001, zoom_speed * delta)
		else:
			current_camera.zoom.x = ratio
			current_camera.zoom.y = ratio
			is_zooming = false
			current_camera.offset.x = goal_position.x
			current_camera.offset.y = goal_position.y
			#zoom_speed = zoom_speed * ratio
			#move_speed = move_speed * ratio
		current_camera.offset.x = lerp(current_camera.offset.x, goal_position.x, move_speed * delta)
		current_camera.offset.y = lerp(current_camera.offset.y, goal_position.y, move_speed * delta)
	if is_dezooming:
		if current_camera.zoom.x < goal_zoom or current_camera.zoom.y < goal_zoom:
			current_camera.zoom.x = lerp(current_camera.zoom.x, 1 + 0.001, zoom_speed * delta)
			current_camera.zoom.y = lerp(current_camera.zoom.y, 1 + 0.001, zoom_speed * delta)
		else:
			current_camera.zoom.x = 1
			current_camera.zoom.y = 1
			is_dezooming = false
			current_camera.offset.x = goal_position.x
			current_camera.offset.y = goal_position.y
			
			#zoom_speed = zoom_speed / ratio
			#move_speed = move_speed / ratio
		current_camera.offset.x = lerp(current_camera.offset.x, goal_position.x, move_speed * delta)
		current_camera.offset.y = lerp(current_camera.offset.y, goal_position.y, move_speed * delta)
