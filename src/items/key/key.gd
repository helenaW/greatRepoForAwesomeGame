extends "res://items/item.gd"

export (NodePath) var lock

func store_custom(item_object):
    item_object.custom.lock = get_node(lock).get_path()
    
func restore_custom(item_object):
    lock = item_object.custom.lock

func use(player):
    if lock != null:
        var lock_node = get_node(lock)
        for area in player.get_facing_areas():
            if area.name == lock_node.name:
                area.unlock(self)
                print('[Key] Unlocking the lock: ', lock_node.name)
                player.inventory.remove_item_by_name(name)
    else:
        print('Key has no lock set!')