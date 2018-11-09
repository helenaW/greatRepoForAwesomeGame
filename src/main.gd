extends Node

onready var player_1_view = $split_1
onready var player_2_view = $split_2

onready var main_view = $view


func _ready():
    player_1_view.set_world_2d(main_view.get_world_2d())
    player_2_view.set_world_2d(main_view.get_world_2d())
    
