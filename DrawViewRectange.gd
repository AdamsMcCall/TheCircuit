tool
extends ViewportContainer

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(512, 288)), Color(255, 0, 0), false, 4, false)

func _process(delta):
	update()
