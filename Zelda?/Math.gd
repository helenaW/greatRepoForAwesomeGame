extends Node2D

func det(a, b):
    return a.x * b.y - a.y * b.x

func line_intersection(line1, line2):
    var xdiff = Vector2(line1[0].x - line1[1].x, line2[0].x - line2[1].x)
    var ydiff = Vector2(line1[0].y - line1[1].y, line2[0].y - line2[1].y)

    var div = det(xdiff, ydiff)
    if div == 0:
       return null

    var d = Vector2(det(line1[0], line1[1]), det(line2[0], line2[1]))
    var x = det(d, xdiff) / div
    var y = det(d, ydiff) / div
    
    return Vector2(x, y)
    
