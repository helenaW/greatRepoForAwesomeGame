extends Node

class item_object:
    """
    Static representation of Item, used for Inventory system and "will"
    be used for representing items when saving/loading data
    """
    var scene_path
    var name
    var usages
    var multiple_uses
    var custom = {}
    
    """
    Creates an item instance
    """
    func create_instance():
        var instance = load(scene_path).instance()
        instance.restore(self)
        return instance
        
    """
    Returnes false if couldn't use, true if used
    """
    func use(player, scene_instance):
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

        
func create(scene_path, name, usages, multiple_uses):
    var item = item_object.new()
    item.scene_path = scene_path
    item.name = name
    item.usages = usages
    item.multiple_uses = multiple_uses
    return item


"""
Restore entity (savegame)
"""
static func restore_savedata(save_data):
    var item = create(
                save_data.scene_path,
                save_data.name,
                save_data.usages,
                save_data.multiple_uses)
    item.custom = save_data.custom
    return item