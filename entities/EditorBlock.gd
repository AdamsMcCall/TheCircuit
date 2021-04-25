extends Node2D

export var is_fixed = true
export var block_type = BlockEnum.TYPE.empty

func _on_remove_placeholders():
	queue_free()
