extends Node2D

enum TYPE {
	empty,
	generator,
	flowLeft,
	flowUp,
	flowRight,
	flowDown,
	output
}

var current_flowing = false

export var block_type = TYPE.generator

onready var sprite = $Sprite
onready var animplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	match block_type:
		TYPE.generator:
			sprite.texture = preload("res://assets/images/block_generator.png")
		TYPE.flowLeft:
			sprite.texture = preload("res://assets/images/block_flow_left.png")
		TYPE.flowUp:
			sprite.texture = preload("res://assets/images/block_flow_up.png")
		TYPE.flowRight:
			sprite.texture = preload("res://assets/images/block_flow_right.png")
		TYPE.flowDown:
			sprite.texture = preload("res://assets/images/block_flow_down.png")
		TYPE.output:
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
