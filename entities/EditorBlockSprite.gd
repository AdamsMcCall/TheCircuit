tool
extends Sprite


func _process(delta):
	_update_texture()

func _update_texture():
	var parent = get_parent()
	match parent.block_type:
		BlockEnum.TYPE.generator:
			texture = preload("res://assets/images/block_generator.png")
		BlockEnum.TYPE.flow:
			texture = preload("res://assets/images/block_flow.png")
		BlockEnum.TYPE.flowLeft:
			texture = preload("res://assets/images/block_flow_left.png")
		BlockEnum.TYPE.flowUp:
			texture = preload("res://assets/images/block_flow_up.png")
		BlockEnum.TYPE.flowRight:
			texture = preload("res://assets/images/block_flow_right.png")
		BlockEnum.TYPE.flowDown:
			texture = preload("res://assets/images/block_flow_down.png")
		BlockEnum.TYPE.output:
			texture = preload("res://assets/images/block_output.png")
		BlockEnum.TYPE.nested:
			texture = preload("res://assets/images/block_nested.png")
