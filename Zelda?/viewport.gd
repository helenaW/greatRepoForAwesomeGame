extends Control

onready var player_1_view = get_node("/root/main/split_1")
onready var player_2_view = get_node("/root/main/split_2")

onready var player_1_camera = get_node("/root/main/split_1/camera")
onready var player_2_camera = get_node("/root/main/split_2/camera")

onready var player_1 = get_node("/root/main/view/world/player_1")
onready var player_2 = get_node("/root/main/view/world/player_2")

export var split_distance = 200
var draw_player_2_view = false
var angle = 0
var player_distance = 0

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
    

func give_perpendicular_vector(vector):
    if vector.x != 0:
        return Vector2(-vector.y/vector.x, 1)
    if vector.y != 0:
        return Vector2(1, -vector.x/vector.y)
    return Vector2()

func _process(delta):
    player_distance = player_1.position.distance_to(player_2.position)
    
    var v = player_1.position-player_2.position
    var per_v = give_perpendicular_vector(v)
    
    angle = per_v.angle()
    if player_1.position.x > player_2.position.x:
        angle += PI
    
    var midpoint_1 = (player_1.position + player_2.position) / 2
    
    if player_distance > split_distance:
        var offset_1 = midpoint_1 - player_1.position
        offset_1.x = clamp(offset_1.x, -split_distance/2, split_distance/2)
        offset_1.y = clamp(offset_1.y, -split_distance/2, split_distance/2)
        midpoint_1 = player_1.position + offset_1
        
        var offset_2 = midpoint_1 - player_2.position
        offset_2.x = clamp(offset_2.x, -split_distance/2, split_distance/2)
        offset_2.y = clamp(offset_2.y, -split_distance/2, split_distance/2)
        var midpoint_2 = player_2.position + offset_2
        
        if !draw_player_2_view:
            draw_player_2_view = true
            player_2_camera.position = player_1_camera.position
            player_2_camera.rotation = player_2_camera.rotation
        else:
            #player_2_camera.position = player_2_camera.position.linear_interpolate(midpoint_2, delta)
            player_2_camera.position = midpoint_2
    else:
        draw_player_2_view = false
    
    #player_1_camera.position = player_1_camera.position.linear_interpolate(midpoint_1, delta)
    player_1_camera.position = midpoint_1
    
    update()
    
func _draw():
    var uvs = [
        Vector2(0,0),
        Vector2(0,1),
        Vector2(1,1),
        Vector2(1,0),
    ]
    var uvs_split = [
        Vector2(0,0),
        Vector2(0,1),
        Vector2(1,1),
        Vector2(1,0),
    ]
    var colors = [
        Color(1,1,1),
        Color(1,1,1),
        Color(1,1,1),
        Color(1,1,1),
    ]
    var rect = [
        [Vector2(0,0), Vector2(0,512)],
        [Vector2(0,512), Vector2(512,512)],
        [Vector2(512,512), Vector2(512,0)],
        [Vector2(512,0), Vector2(0,0)],
    ]
    
    var seperator_line = [
        Vector2(256, 256),
        Vector2(-1, 0).rotated(angle) * 512
    ]
    var split_points = []
    var static_split_points = [Vector2(), Vector2()]
    var intersect_a = null
    var intersect_b = null
    
    for index in range(rect.size()):
        var point = line_intersection(seperator_line, rect[index])
        if point.x <= 512 and point.x >= 0 and point.y <= 512 and point.y >= 0:
            if intersect_a == null:
                intersect_a = point
            else:
                intersect_b = point
    
    ###
    #  0--1
    #  |  |
    #  a--b
    #  |  |
    #  ----
    ###
    if intersect_a.x == 0 and intersect_b.x == 512 and player_2.position.y < player_1.position.y:
        #print('AA<')
        static_split_points[1].x = 512
        split_points = [
            static_split_points[0],
            intersect_a,
            intersect_b,
            static_split_points[1],
        ]
        uvs_split = [
            Vector2(0,0),
            Vector2(0,intersect_a.y/512),
            Vector2(1,intersect_b.y/512),
            Vector2(1,0),
        ]
        
    ###
    #  ----
    #  |  |
    #  a--b
    #  |  |
    #  0--1
    ###
    elif intersect_a.x == 0 and intersect_b.x == 512 and player_2.position.y > player_1.position.y:
        #print('AA>')
        static_split_points[0].y = 512
        static_split_points[1].x = 512
        static_split_points[1].y = 512
        split_points = [
            intersect_a,
            static_split_points[0],
            static_split_points[1],
            intersect_b,
        ]
        uvs_split = [
            Vector2(0,intersect_a.y/512),
            Vector2(0,1),
            Vector2(1,1),
            Vector2(1,intersect_b.y/512),
        ]

    ###
    #  ---b--0
    #  |  |  |
    #  ---a--1
    ###
    elif intersect_b.y == 0 and intersect_a.y == 512 and player_2.position.x > player_1.position.x:
        #print('BB>')
        static_split_points[0].x = 512
        static_split_points[1].x = 512
        static_split_points[1].y = 512
        split_points = [
            intersect_b,
            intersect_a,
            static_split_points[1],
            static_split_points[0],
        ]
        uvs_split = [
            Vector2(intersect_b.x/512,0),
            Vector2(intersect_a.x/512,1),
            Vector2(1,1),
            Vector2(1,0),
        ]
        
    ###
    #  0--b---
    #  |  |  |
    #  1--a---
    ###
    elif intersect_b.y == 0 and intersect_a.y == 512 and player_2.position.x < player_1.position.x:
        #print('BB<')
        static_split_points[1].y = 512
        split_points = [
            static_split_points[0],
            static_split_points[1],
            intersect_a,
            intersect_b,
        ]
        uvs_split = [
            Vector2(0,0),
            Vector2(0,1),
            Vector2(intersect_a.x/512,1),
            Vector2(intersect_b.x/512,0),
        ]

    # Draw player_1 view
    draw_primitive(
        [
            Vector2(0,0),
            Vector2(0,512),
            Vector2(512,512),
            Vector2(512,0),
        ],
        colors,
        uvs,
        player_1_view.get_texture())
    
    # Draw player_2 view and seperator line
    if draw_player_2_view:
        # Split
        draw_primitive(
            split_points,
#            [
#                Color(1,0,1),
#                Color(1,0,1),
#                Color(1,0,1),
#                Color(1,0,1),
#            ],
            colors,
            uvs_split,
            player_2_view.get_texture())
        # Seperator
        draw_set_transform(Vector2(0,0), 0, Vector2(1,1))
        draw_polyline([intersect_a, intersect_b], Color(1,1,1), clamp(sqrt(player_distance)-sqrt(split_distance), 0, 10))

