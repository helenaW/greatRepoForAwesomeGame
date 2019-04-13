class_name InventoryItem
"""
Static representation of Item, used for Inventory system and 'will'
be used for representing items when saving/loading data
"""

var scene_path: String
var name: String
var usages: int
var multiple_uses: bool
var custom = {}

func _init():
    pass

"""
Creates an item instance
"""
func create_instance() -> InventoryItem:
    var instance = load(scene_path).instance()
    instance.restore(self)
    return instance

"""
Returnes false if couldn't use, true if used
"""
func use(player, scene_instance) -> bool:
    if multiple_uses and usages < 0:
        return false

    scene_instance.restore(self)
    scene_instance.use(player)

    return true

"""
Store entity (savegame)
"""
func store_savedata():
    return {
        'scene_path'    : scene_path,
        'name'          : name,
        'usages'        : usages,
        'multiple_uses' : multiple_uses,
        'custom'        : custom,
       }
