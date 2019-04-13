extends Node

var save_data
var initial_save_data = {
    'level'      : 'levels/begining.tscn',
    'persistent' : {},
    'first_time' : true,
    
    # TODO: It should meybe have to go somewhere else
    'player_one_character': null,
    'player_two_character': null,
}

var savegame_file = File.new()
var save_path = "user://savegame.bin"

func _write_to_file() -> void:
    savegame_file.open_encrypted_with_pass(save_path, File.WRITE, "asd")
    savegame_file.store_var(save_data)
    savegame_file.close()

func _read_from_file() -> void:
    savegame_file.open_encrypted_with_pass(save_path, File.READ, "asd")
    save_data = savegame_file.get_var()
    savegame_file.close()

"""
Loads save data from save game file
"""
func load_savegame():
    if not savegame_file.file_exists(save_path):
        print('[SaveGame] Loading from disk - NEW')
        initialize_savedata()
        _write_to_file()
    else:
        print('[SaveGame] Loading from disk - EXISTING')
        _read_from_file()
        
    return save_data
        
"""
Writes save_data to save game file
"""
func write_savegame() -> void:
    print('[SaveGame] Writing to disk')
    _write_to_file()

"""
Writes fresh save_data to save game file
"""
func delete_savegame() -> void:
    print('[SaveGame] Deleting from disk')
    initialize_savedata()
    _write_to_file()

"""
Initializes save_data. Used when creating new game
"""
func initialize_savedata() -> void:
    print('[SaveGame] Initializing SaveData')
    save_data = initial_save_data.duplicate()
    
#    for node in get_tree().get_nodes_in_group("persistant"):
#        save_data.persistent[node.name] = node.store_savedata()

"""
Stores all persistant nodes
"""
func store_savedata() -> void:
    save_data.persistent = {}
    save_data.first_time = false
    for node in get_tree().get_nodes_in_group("persistant"):
        save_data.persistent[node.name] = node.store_savedata()

"""
Restore all persitant nodes
"""
func restore_savedata(save_data) -> void:
    print('[SaveGame] Restoring from save_data')
    for node in get_tree().get_nodes_in_group("persistant"):
        if save_data.persistent.has(node.name):
            print('[SaveGame] RESTORING node as it was found in save_data: ', node.name)
            node.restore_savedata(save_data.persistent[node.name])
        elif not save_data.first_time:
            print('[SaveGame] DELETING node as not save_data and not first_time: ', node.name)
            # If not in saved data, delete
            node.queue_free()
        elif node.name == 'player_1' or node.name == 'player_2':
            # players are special case, as they are not part of the level, so are the same instance
            # not recreated. for this reason we need to clear them after doing new_game
            print('[SaveGame] FIRST TIME RESTORE node as game is loading fresh new game: ', node.name)
            node.clear_savedata();


"""
Stores level to save_data (not saved to disk!)
"""
func store_level(level) -> void:
    save_data.level = level.filename
    
func set_player_one_character(character) -> void:
    save_data.player_one_character = character
  
func set_player_two_character(character) -> void:
    save_data.player_two_character = character
 