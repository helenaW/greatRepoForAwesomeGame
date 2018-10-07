extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _draw():
    draw_line(to_local(Vector2(0,0)), to_local(Vector2(512,0)), Color(0,0,0), 10.0)