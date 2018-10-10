extends Node

onready var main_viewport = $Viewports/MainView/View
onready var split_viewport = $Viewports/SplitView/View
onready var main_camera = $Viewports/MainView/View/Camera
onready var split_camera = $Viewports/SplitView/View/Camera
onready var world = $Viewports/MainView/View/World
onready var player1 = world.get_node('Player 1')
onready var player2 = world.get_node('Player 2')
onready var split = $Split
onready var splitter = $Splitter

func _ready():
    print(main_viewport.world_2d)
    print(split_viewport.world_2d)
    split_viewport.world_2d = main_viewport.world_2d

    main_camera.player_target = player1
    split_camera.player_target = player2
    
#func _process(delta):
#     var player_distance = player1.position.distance_to(player2.position)
#     var player_x_distance = player1.position.x - player2.position.x

#     var angle
#     if player1.position.x <= player2.position.x:
#         angle = acos(player_x_distance / player_distance)
#     else:
#         angle = deg2rad(rad2deg(asin(player_x_distance / player_distance)) - 90)

#     # splitter.rotate(angle)

#     #if 1 < 100:
#         #camera1.position_target = (player1.get_global_pos() + player2.get_global_pos()) * 0.5
#         #camera2.current = false
#     #else:
#         #camera2.current = true
