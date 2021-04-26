extends Node2D

signal tick
signal remove_placeholders
signal set_active(state)

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
export var height = 8
var output_nb = 0
var succeeded = false

var has_started = false

onready var timer = $Timer

func _ready():
	map.resize(width * height)
	_parse_blocks()
	emit_signal("tick")

func _parse_blocks():
	var children = get_children()
	for child in children:
		if child.is_in_group("editor_tools"):
			# warning-ignore:return_value_discarded
			connect("remove_placeholders", child, "_on_remove_placeholders")
			_add_block_at(child.block_type, (child.position.x / 32), (child.position.y / 32), child.is_fixed)
			if child.block_type == BlockEnum.TYPE.output:
				output_nb += 1
	emit_signal("remove_placeholders")

func _add_block_at(block_type, x, y, is_fixed):
	if (x + y * width) > (width * height) or block_type == BlockEnum.TYPE.empty:
		return
	var block = block_scene.instance()
	block.position = Vector2(x * 32, y * 32)
	block.block_type = block_type
	block.is_fixed = is_fixed
# warning-ignore:return_value_discarded
	connect("tick", block, "_on_tick")
	connect("set_active", block, "set_active")
	map[x + y * width] = block
	add_child(block)
	return block

func _on_Timer_timeout():
	update_map()

func update_map():
	var menubar = get_parent().get_node("MenuBar")
	menubar.is_running = true
	var active_output_nb = 0
	current_map = []
	for i in map.size():
		current_map.append(0)
	for j in current_map.size():
		if map[j] != null:
			if map[j].current_flowing:
				_update_current_flow(j)
	for k in current_map.size():
		if map[k] != null:
			if current_map[k] == 1 and map[k].current_cooldown == 0:
				map[k].current_flowing = true
			else:
				map[k].current_flowing = false
			if map[k].block_type == BlockEnum.TYPE.output and map[k].current_flowing:
				active_output_nb += 1
	emit_signal("tick")
	if active_output_nb == output_nb and output_nb > 0:
		menubar.is_success = true
		succeeded = true
	else:
		menubar.is_success = false
		succeeded = false

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
		BlockEnum.TYPE.flow:
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
		BlockEnum.TYPE.nested:
			var vpcontent = get_parent().get_parent().get_children()
			for node in vpcontent:
				if node is ViewportContainer:
					var deeper_circuit = node.get_node("Viewport/" + node.name + "Content/Circuit")
					print(deeper_circuit.succeeded)
					if deeper_circuit.succeeded:
						if (x > 0):
							current_map[(x - 1) + y * width] = 1
						if (x < width - 1):
							current_map[(x + 1) + y * width] = 1
						if (y > 0):
							current_map[x + (y - 1) * width] = 1
						if (y < height - 1):
							current_map[x + (y + 1) * width] = 1
					else:
						current_map[pos] = 1
					deeper_circuit.update_map()

func reset_map():
	timer.stop()
	for i in map.size():
		if map[i] != null:
			if map[i].block_type != BlockEnum.TYPE.empty and map[i].block_type != BlockEnum.TYPE.generator:
				map[i].current_flowing = false
			elif map[i].block_type == BlockEnum.TYPE.generator:
				map[i].current_flowing = true
	emit_signal("tick")
