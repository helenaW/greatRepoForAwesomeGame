extends Node

onready var player_1_view = $split_1
onready var player_2_view = $split_2

onready var main_view = $view
onready var level = $view/level

onready var player_1 = $view/player_1
onready var player_2 = $view/player_2

func _ready():
    var save_data = save_game.load_savegame()
    
    load_from_savedata(save_data)
    
    player_1_view.set_world_2d(main_view.get_world_2d())
    player_2_view.set_world_2d(main_view.get_world_2d())
    

func load_from_savedata(save_data):
    var level = load(save_data.level).instance()
    
    switch_level(level)
    
    save_game.restore_savedata(save_data)
    
func store_savedata():
    save_game.store_level(level)
    save_game.store_savedata()
    save_game.write_savegame()
    
func switch_level(new_level):
    
    level.queue_free()
    main_view.add_child(new_level)
    main_view.move_child(new_level, 0)
    level = new_level
    
    level.start_level(player_1, player_2)
