extends Node2D

var current_flowing = false
var current_cooldown = 0
var block_rotation = 0
var is_fixed = true

var block_type = BlockEnum.TYPE.empty

onready var sprite = $Sprite
onready var animplayer = $AnimationPlayer
onready var screws_sprite = $Screws

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_texture()

func _process(delta):
	screws_sprite.visible = is_fixed
	if Input.is_action_just_pressed("left_click"):
		var mouse_position = get_global_mouse_position()
		if mouse_position.x > global_position.x - 16 * scale.x \
		and mouse_position.x < global_position.x + 16 * scale.x \
		and mouse_position.y > global_position.y - 16 * scale.y \
		and mouse_position.y < global_position.y + 16 * scale.y:
			if (block_type == BlockEnum.TYPE.flowDown
			or block_type == BlockEnum.TYPE.flowUp
			or block_type == BlockEnum.TYPE.flowLeft
			or block_type == BlockEnum.TYPE.flowRight) \
			and !is_fixed \
			and !get_parent().has_started:
				block_rotation += 1
				if block_rotation > 3:
					block_rotation = 0
				block_type = block_rotation + BlockEnum.TYPE.flowLeft
				_update_texture()

func _on_tick():
	if current_flowing:
		animplayer.play("on")
		if block_type != BlockEnum.TYPE.output:
			current_cooldown = 2
	else:
		animplayer.play("off")
		if current_cooldown > 0:
			current_cooldown -= 1

func _update_texture():
	match block_type:
		BlockEnum.TYPE.generator:
			sprite.texture = preload("res://assets/images/block_generator.png")
			current_flowing = true
		BlockEnum.TYPE.flow:
			sprite.texture = preload("res://assets/images/block_flow.png")
		BlockEnum.TYPE.flowLeft:
			sprite.texture = preload("res://assets/images/block_flow_left.png")
			block_rotation = 0
		BlockEnum.TYPE.flowUp:
			sprite.texture = preload("res://assets/images/block_flow_up.png")
			block_rotation = 1
		BlockEnum.TYPE.flowRight:
			sprite.texture = preload("res://assets/images/block_flow_right.png")
			block_rotation = 2
		BlockEnum.TYPE.flowDown:
			sprite.texture = preload("res://assets/images/block_flow_down.png")
			block_rotation = 3
		BlockEnum.TYPE.output:
			sprite.texture = preload("res://assets/images/block_output.png")
