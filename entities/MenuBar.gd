extends Node2D

onready var sprite = $Sprite
onready var working_texture = preload("res://assets/images/toolbar.png")
var is_running = false
onready var running_texture = preload("res://assets/images/toolbar_running.png")
var is_success = false
onready var success_texture = preload("res://assets/images/toolbar_success.png")

func _process(delta):
	if is_success:
		sprite.texture = success_texture
	elif is_running:
		sprite.texture = running_texture
	else:
		sprite.texture = working_texture
	var grid = get_node("GridBackground")
	grid.is_running = is_running
	grid.is_success = is_success
