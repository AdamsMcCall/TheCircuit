extends Node2D


onready var sprite = $Sprite
onready var working_texture = preload("res://assets/images/grid.png")
var is_running = false
onready var running_texture = preload("res://assets/images/grid_running.png")
var is_success = false
onready var success_texture = preload("res://assets/images/grid_success.png")

func _process(delta):
	if is_success:
		sprite.texture = success_texture
	elif is_running:
		sprite.texture = running_texture
	else:
		sprite.texture = working_texture
