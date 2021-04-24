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
var current_map = []
export var width = 16
export var height = 9

onready var timer = $Timer

func _ready():
	map.resize(width * height)
	_add_block_at(BlockEnum.TYPE.generator, 1, 1)
	_add_block_at(BlockEnum.TYPE.flowRight, 2, 1)
	_add_block_at(BlockEnum.TYPE.flowDown, 3, 1)
	_add_block_at(BlockEnum.TYPE.flowRight, 3, 2)
	_add_block_at(BlockEnum.TYPE.flowRight, 4, 2)
	_add_block_at(BlockEnum.TYPE.output, 5, 2)
	_add_block_at(BlockEnum.TYPE.flowDown, 1, 2)
	_add_block_at(BlockEnum.TYPE.flowLeft, 1, 3)
	_add_block_at(BlockEnum.TYPE.flowDown, 0, 3)
	_add_block_at(BlockEnum.TYPE.flowDown, 0, 4)
	_add_block_at(BlockEnum.TYPE.flowDown, 0, 5)
	_add_block_at(BlockEnum.TYPE.flowDown, 0, 6)
	_add_block_at(BlockEnum.TYPE.flowRight, 0, 7)
	_add_block_at(BlockEnum.TYPE.flowRight, 1, 7)
	_add_block_at(BlockEnum.TYPE.flowUp, 2, 7)
	_add_block_at(BlockEnum.TYPE.output, 2, 6)
	emit_signal("tick")

func _add_block_at(block_type, x, y):
	if (x + y * width) > (width * height) or block_type == BlockEnum.TYPE.empty:
		pass
	var block = block_scene.instance()
	block.position = Vector2(x * 32, y * 32)
	block.block_type = block_type
# warning-ignore:return_value_discarded
	connect("tick", block, "_on_tick")
	map[x + y * width] = block
	add_child(block)

func _on_Timer_timeout():
	update_map()

func update_map():
	current_map = []
	for i in map.size():
		current_map.append(0)
	for j in current_map.size():
		if map[j] != null:
			if map[j].current_flowing:
				_update_current_flow(j)
	for k in current_map.size():
		if map[k] != null:
			if current_map[k] == 1:
				map[k].current_flowing = true
			else:
				map[k].current_flowing = false
	emit_signal("tick")

func _update_current_flow(pos):
	var x = pos % width
	var y = pos / width
	match map[pos].block_type:
		BlockEnum.TYPE.generator:
			if (x > 0):
				current_map[(x - 1) + y * width] = 1
			if (x < width - 1):
				current_map[(x + 1) + y * width] = 1
			if (y > 0):
				current_map[x + (y - 1) * width] = 1
			if (y < height - 1):
				current_map[x + (y + 1) * width] = 1
		BlockEnum.TYPE.flowLeft:
			if (x > 0):
				current_map[(x - 1) + y * width] = 1
		BlockEnum.TYPE.flowUp:
			if (y > 0):
				current_map[x + (y - 1) * width] = 1
		BlockEnum.TYPE.flowRight:
			if (x < width - 1):
				current_map[(x + 1) + y * width] = 1
		BlockEnum.TYPE.flowDown:
			if (y < height - 1):
				current_map[x + (y + 1) * width] = 1
		BlockEnum.TYPE.output:
			current_map[pos] = 1

func reset_map():
	timer.stop()
	for i in map.size():
		if map[i] != null:
			if map[i].block_type != BlockEnum.TYPE.empty and map[i].block_type != BlockEnum.TYPE.generator:
				map[i].current_flowing = false
			elif map[i].block_type == BlockEnum.TYPE.generator:
				map[i].current_flowing = true
	emit_signal("tick")
