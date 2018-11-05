extends Control

onready var MathHelper = get_node("/root/main/MathHelper")

onready var player_1_view = get_node("/root/main/split_1")
onready var player_2_view = get_node("/root/main/split_2")

onready var player_1_camera = get_node("/root/main/split_1/camera")
onready var player_2_camera = get_node("/root/main/split_2/camera")

onready var player_1 = get_node("/root/main/view/world/player1")
onready var player_2 = get_node("/root/main/view/world/player2")

export var split_distance = 200
var draw_player_2_view = false
var angle = 0
var player_distance = 0

func give_perpendicular_vector(vector):
    if vector.x != 0:
        return Vector2(-vector.y/vector.x, 1)
    if vector.y != 0:
        return Vector2(1, -vector.x/vector.y)
    return null

func _process(delta):
    player_distance = player_1.position.distance_to(player_2.position)
    
    var v = player_1.position-player_2.position
    var per_v = give_perpendicular_vector(v)
    
    angle = per_v.angle()
    
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
            player_2_camera.position = player_2_camera.position.linear_interpolate(midpoint_2, delta)
            # player_2_camera.rotation = angle
    else:
        draw_player_2_view = false
    
    player_1_camera.position = player_1_camera.position.linear_interpolate(midpoint_1, delta)
    
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
    
    var split_line_points = []
    var split_points = []
    
    for i in range(4):
        split_points.append(null)
    
    for index in range(rect.size()):
        var point = MathHelper.line_intersection(seperator_line, rect[index])
        if point.x <= 512 and point.x >= 0 and point.y <= 512 and point.y >= 0:
            if split_points[0] == null:
                split_points[0] = point
            else:
                split_points[3] = point

            split_line_points.append(point)
    
    split_points[1] = Vector2(0,0)
    split_points[2] = Vector2(0,0)
    
    var a = split_points[0]
    var b = split_points[3]
    
    ###
    #  1--2
    #  |  |
    #  a--b
    #  |  |
    #  ----
    ###
    if a.x == 0 and b.x == 512 and player_2.position.y < player_1.position.y:
        print('AA<')
        split_points[2].x = 512
        split_points = [
            split_points[1],
            a,
            b,
            split_points[2],
        ]
        uvs_split = [
            Vector2(0,0),
            Vector2(0,a.y/512),
            Vector2(1,b.y/512),
            Vector2(1,0),
        ]
        
    ###
    #  ----
    #  |  |
    #  a--b
    #  |  |
    #  1--2
    ###
    elif a.x == 0 and b.x == 512 and player_2.position.y > player_1.position.y:
        print('AA>')
        split_points[1].y = 512
        split_points[2].x = 512
        split_points[2].y = 512
        split_points = [
            a,
            split_points[1],
            split_points[2],
            b,
        ]
        uvs_split = [
            Vector2(0,a.y/512),
            Vector2(0,1),
            Vector2(1,1),
            Vector2(1,b.y/512),
        ]

    ###
    #  ---b--1
    #  |  |  |
    #  ---a--2
    ###
    elif b.y == 0 and a.y == 512 and player_2.position.x > player_1.position.x:
        print('BB>')
        split_points[1].x = 512
        split_points[2].x = 512
        split_points[2].y = 512
        split_points = [
            b,
            a,
            split_points[2],
            split_points[1],
        ]
        uvs_split = [
            Vector2(b.x/512,0),
            Vector2(a.x/512,1),
            Vector2(1,1),
            Vector2(1,0),
        ]
        
    ###
    #  1--b---
    #  |  |  |
    #  2--a---
    ###
    elif b.y == 0 and a.y == 512 and player_2.position.x < player_1.position.x:
        print('BB<')
        split_points[2].y = 512
        split_points = [
            split_points[1],
            split_points[2],
            a,
            b,
        ]
        uvs_split = [
            Vector2(0,0),
            Vector2(0,1),
            Vector2(a.x/512,1),
            Vector2(b.x/512,0),
        ]

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
    
    if draw_player_2_view:
        
        # Split
        draw_primitive(
            split_points,
            [
                Color(1,0,1),
                Color(1,0,1),
                Color(1,0,1),
                Color(1,0,1),
            ],
            uvs_split,
            player_2_view.get_texture())
        # Seperator
        draw_set_transform(Vector2(0,0), 0, Vector2(1,1))
        draw_polyline(split_line_points, Color(1,1,1), clamp(player_distance/2-split_distance, 0, 15))

