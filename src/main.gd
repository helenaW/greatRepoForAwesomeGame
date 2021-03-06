extends Node

onready var player_1_view = $split_1
onready var player_2_view = $split_2

onready var main_view = $view
onready var level = $view/level

onready var player_1 = $view/player_1
onready var player_2 = $view/player_2

onready var ui_viewport = $ui/viewport
onready var ui_node = $ui

var LOADING_GAME = false

func _ready():
    settings.connect("settings_change", self, "_on_settings_change")
    
    var save_data = save_game.load_savegame()
    
    load_from_savedata(save_data)
    
    player_1_view.set_world_2d(main_view.get_world_2d())
    player_2_view.set_world_2d(main_view.get_world_2d())
    
    player_1.additional_restore()
    player_2.additional_restore()
    
func apply_viewport_resolution():
    player_1_view.size = settings.settings_data.resolution
    player_2_view.size = settings.settings_data.resolution
    main_view.size = settings.settings_data.resolution
    ui_viewport.rect_size = settings.settings_data.resolution
    ui_node.rect_size = settings.settings_data.resolution
    # TODO: Each node should resize itself, we shouldnt set all the ui elemnts from here!
    # But the problem is that then every node needs to listen on "settings_change" event...

func load_from_savedata(save_data):
    LOADING_GAME = true
    var level = load(save_data.level).instance()
    
    switch_level(level)
    
    # Needed in case player is on top of a item spawn location
    # without this, he picks up the item while game is being restored
    # this ensures that it doese not happen.
    yield(get_tree(), "idle_frame")

    save_game.restore_savedata(save_data)
    LOADING_GAME = false

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

func _on_settings_change():
    apply_viewport_resolution()