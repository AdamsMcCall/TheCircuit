extends Node2D

var current_flowing = false
var current_cooldown = 0

var block_type = BlockEnum.TYPE.empty

onready var sprite = $Sprite
onready var animplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match block_type:
		BlockEnum.TYPE.generator:
			sprite.texture = preload("res://assets/images/block_generator.png")
			current_flowing = true
		BlockEnum.TYPE.flow:
			sprite.texture = preload("res://assets/images/block_flow.png")
		BlockEnum.TYPE.flowLeft:
			sprite.texture = preload("res://assets/images/block_flow_left.png")
		BlockEnum.TYPE.flowUp:
			sprite.texture = preload("res://assets/images/block_flow_up.png")
		BlockEnum.TYPE.flowRight:
			sprite.texture = preload("res://assets/images/block_flow_right.png")
		BlockEnum.TYPE.flowDown:
			sprite.texture = preload("res://assets/images/block_flow_down.png")
		BlockEnum.TYPE.output:
			sprite.texture = preload("res://assets/images/block_output.png")

func _on_tick():
	if current_flowing:
		animplayer.play("on")
		if block_type != BlockEnum.TYPE.output:
			current_cooldown = 2
	else:
		animplayer.play("off")
		if current_cooldown > 0:
			current_cooldown -= 1
