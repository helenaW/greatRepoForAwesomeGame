extends Node

var save_data
var initial_save_data = {
    'level'    : 'levels/begining.tscn',
    'player_1' : {
        'inventory': {
            'items': [],
            'selected_item': null,
        },
        'position' : Vector2(),
    },
    'player_2' : {
        'inventory': {
            'items': [],
            'selected_item': null,
        },
        'position' : Vector2(),
   },
}


var savegame_file = File.new()
var save_path = "user://savegame.bin"

func _write_to_file():
    savegame_file.open_encrypted_with_pass(save_path, File.WRITE, OS.get_unique_id())
    savegame_file.store_var(save_data)
    savegame_file.close()

func _read_from_file():
    savegame_file.open_encrypted_with_pass(save_path, File.READ, OS.get_unique_id())
    save_data = savegame_file.get_var()

"""
Loads save data from save game file
"""
func load_savegame():
    if not savegame_file.file_exists(save_path):
        print('[SaveGame] Loading from disk - NEW')
        save_data = initial_save_data.duplicate()
        _write_to_file()
    else:
        print('[SaveGame] Loading from disk - EXISTING')
        _read_from_file()
        
    return save_data
        
"""
Writes save_data to save game file
"""
func write_savegame():
    print('[SaveGame] Writing to disk')
    _write_to_file()

"""
Writes fresh save_data to save game file
"""
func delete_savegame():
    print('[SaveGame] Deleting from disk')
    save_data = initial_save_data.duplicate()
    _write_to_file()

"""
Stores player data to save_data (not saved to disk!)
"""
func store_player(player):
    print('[SaveGame] Storing player: ', player.name)
    
    save_data[player.name].inventory.items = player.inventory.items
    save_data[player.name].inventory.selected_item = player.inventory.selected_item_index
    save_data[player.name].position = player.position
    
"""
Restores player from save_data
"""
func restore_player(player):
    print('[SaveGame] Restoring player: ', player.name)

    var player_save_data = save_data[player.name]
    
    print(player.position, player_save_data.position)
    
    player.inventory.set_inventory_items(player_save_data.inventory.items)
    player.inventory.set_selected_item(player_save_data.inventory.selected_item)
    player.position = player_save_data.position
    
    

"""
Stores level to save_data (not saved to disk!)
"""
func store_level(level):
    save_data.level = level.filename
    