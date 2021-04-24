extends Node2D


var enabled = false
onready var animator = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Circuit_tick():
	if enabled:
		enabled = false
		animator.play("off")
	else:
		enabled = true
		animator.play("on")
