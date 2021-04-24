extends Node2D


var current_flowing = false

var block_type = BlockEnum.TYPE.empty

onready var sprite = $Sprite
onready var animplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match block_type:
		BlockEnum.TYPE.generator:
			sprite.texture = preload("res://assets/images/block_generator.png")
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_tick():
	if current_flowing:
		current_flowing = false
		animplayer.play("off")
	else:
		current_flowing = true
		animplayer.play("on")
