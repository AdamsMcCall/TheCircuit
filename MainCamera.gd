extends Camera2D

var zoom_speed = 0.03
var ratio = 0.03125
var is_zooming = false
var current_layer_nb = 0
onready var current_layer = get_parent().get_parent()
var goal_position = Vector2(0, 0)

func go_deeper():
	is_zooming = true
	current_layer_nb += 1
	current_layer = current_layer.get_node("Viewport/Layer" + str(current_layer_nb)) as ViewportContainer
	goal_position.x = current_layer.rect_position.x + (current_layer.rect_size.x / 2)
	goal_position.y = current_layer.rect_position.y + (current_layer.rect_size.y / 2)
	
func _process(delta):
	if is_zooming:
		if zoom.x > ratio or zoom.y > ratio:
			zoom.x = lerp(zoom.x, ratio - 0.001, zoom_speed)
			zoom.y = lerp(zoom.y, ratio - 0.001, zoom_speed)
		else:
			zoom.x = ratio
			zoom.y = ratio
			is_zooming = false
			offset.x = goal_position.x
			offset.y = goal_position.y
		offset.x = lerp(offset.x, goal_position.x, 0.05)
		offset.y = lerp(offset.y, goal_position.y, 0.05)
