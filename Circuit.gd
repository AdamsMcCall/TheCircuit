extends Node2D

signal tick

var block_scene = preload("res://entities/Block.tscn")

# coordinates formula:
# from X,Y to I:
# x + y * width
# from I to X,Y:
# x = i % width
# y = i / height
var map = []
export var width = 16
export var height = 9

func _ready():
	map.resize(width * height)
	_add_block_at(BlockEnum.TYPE.generator, 1, 1)
	_add_block_at(BlockEnum.TYPE.flowRight, 2, 1)
	_add_block_at(BlockEnum.TYPE.flowDown, 3, 1)
	_add_block_at(BlockEnum.TYPE.flowRight, 3, 2)
	_add_block_at(BlockEnum.TYPE.flowRight, 4, 2)
	_add_block_at(BlockEnum.TYPE.output, 5, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _add_block_at(block_type, x, y):
	if (x + y * width) > (width * height) or block_type == BlockEnum.TYPE.empty:
		pass
	var block = block_scene.instance()
	block.position = Vector2(x * 32, y * 32)
	block.block_type = block_type
	connect("tick", block, "_on_tick")
	map[x + y * width] = block
	add_child(block)

func _on_Timer_timeout():
	emit_signal("tick")
