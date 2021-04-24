extends Node2D

signal tick

enum BLOCKTYPE {
	empty,
	generator,
	flowLeft,
	flowUp,
	flowRight,
	flowDown
}

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
	for i in range(width * height):
		map.append(BLOCKTYPE.empty)
	_add_block_at(BLOCKTYPE.generator, 1, 1)
	_add_block_at(BLOCKTYPE.flowRight, 2, 1)
	_add_block_at(BLOCKTYPE.flowDown, 3, 1)
	_add_block_at(BLOCKTYPE.flowRight, 3, 2)
	_add_block_at(BLOCKTYPE.flowRight, 4, 2)
	
	for j in map.size():
		if map[j] != BLOCKTYPE.empty:
			var block = block_scene.instance()
			block.position = Vector2((j % width) * 32, (j / width) * 32)
			block.block_type = map[j]
			connect("tick", block, "_on_tick")
			add_child(block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _add_block_at(block_type, x, y):
	if (x + y * width) > (width * height):
		pass
	map[x + y * width] = block_type

func _on_Timer_timeout():
	emit_signal("tick")
