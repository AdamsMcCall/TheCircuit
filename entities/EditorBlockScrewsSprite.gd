tool
extends Sprite


func _process(delta):
	var parent = get_parent()
	visible = parent.is_fixed
