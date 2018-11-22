extends Node

onready var player_1_view = $split_1
onready var player_2_view = $split_2

onready var main_view = $view
onready var level = $view/level

onready var player_1 = $view/level/player_1
onready var player_2 = $view/level/player_2

func _ready():
    var save_data = save_game.load_savegame()
    
    load_from_savedata(save_data)
    
    player_1_view.set_world_2d(main_view.get_world_2d())
    player_2_view.set_world_2d(main_view.get_world_2d())
    

func load_from_savedata(save_data):
    var level = load(save_data.level).instance()
    
    switch_level(level)
    
    save_game.restore_player(player_1)
    save_game.restore_player(player_2)
    
func store_savedata():
    save_game.store_level(level)
    save_game.store_player(player_1)
    save_game.store_player(player_2)
    
func switch_level(new_level):
    var player_1 = $view/level/player_1
    var player_2 = $view/level/player_2
    
    level.replace_by(new_level)
    level.queue_free()
    level = new_level
    
    level.start_level(player_1, player_2)
