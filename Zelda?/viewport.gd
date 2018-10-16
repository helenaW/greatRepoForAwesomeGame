extends Control

onready var player_1_view = get_node("/root/main/split_1")
onready var player_2_view = get_node("/root/main/split_2")

onready var player_1_camera = get_node("/root/main/split_1/camera")
onready var player_2_camera = get_node("/root/main/split_2/camera")

onready var player_1 = get_node("/root/main/view/world/player1")
onready var player_2 = get_node("/root/main/view/world/player2")

export var split_distance = 200
var draw_player_2_view = false
var angle = 0


func _process(delta):
    var distance = player_1.position.distance_to(player_2.position)
    print("distance: ", distance)
    
    angle = player_1.position.angle_to(player_2.position) - 90
    
    if player_1.position.y >= player_2.position.y:
        angle = player_1.position.angle_to(player_2.position)
    print("angle: ", angle)
    
    
    var midpoint_1 = (player_1.position + player_2.position) / 2
    print("midpoint: ", midpoint_1)   
    
    if distance > split_distance:
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
            #player_2_camera.rotation = player_2_view_rotation
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
    var colors = [
        Color(1,1,1),
        Color(1,1,1),
        Color(1,1,1),
        Color(1,1,1),
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
        draw_set_transform(Vector2(256,256), 0, Vector2(1,1))
        draw_primitive(
            [
                Vector2(-512,512),
                Vector2(512,512),
                Vector2(512,0),
                Vector2(-512,0),
            ],
            colors,
            uvs,
            player_2_view.get_texture())

    # Draw seperator
    draw_set_transform(Vector2(256,256), angle, Vector2(1,1))
    draw_line(
        Vector2(-512, 0),
        Vector2(512, 0),
        Color(0,0,0),
        10)

