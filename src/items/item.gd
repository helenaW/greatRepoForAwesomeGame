extends Node2D

onready var main = get_node("/root/main")


"""
ITEM

It represents an Item that can be placed in the world, picked up by the player
and used. Should be placed on main node, with child nodes with tree like this:
    
item
|- Sprite
|- Area2D (piclabe with body_entered event linked to "add_to_inventory_event"
   |- CollisionShape2D (represents and area that will make object be picked up by player)

"""

export (bool) var pickable = true
export (int) var usages = 1
export (bool) var multiple_uses = true

"""
Should be used by Area2D to send event on "body_entered",
this way it can be added to inventory if pickable
"""
func add_to_inventory_event(body: PhysicsBody2D):
    if pickable and (body.name == "player_1" || body.name =="player_2"):
        if not main.LOADING_GAME:
            store(body.inventory)
            queue_free()

"""
Should be implemented by each usable item. It dose an action when player uses the item
"""
func use(player):
    var item = player.inventory.get_item_in_use()
    if item.multiple_uses:
        item.usages-= 1
        if item.usages <= 0:
            player.inventory.remove_item(item)
            print('[Item] Removing item as its out of usages: ', name)
        
    print('[Item] Tried to use item: ', name)

"""
It restores Item to what is saved in inventory
Can be extended by items, if they have some custom properties that need to be restored
"""
func restore(item_object: InventoryItem) -> void:
    print('[Item] Restoring from item_object: ', name)
    usages = item_object.usages
    multiple_uses = item_object.multiple_uses
    pickable = false # It's not pickable anymore as is in our inventory
    restore_custom(item_object)

"""
Restore custom information, this should be extended by items if they need
to restore custom information
Should be used in combination with "store_additional"
"""
func restore_custom(item_object: InventoryItem) -> void:
    pass

"""
It stores current item state to inventory
"""
func store(inventory) -> void:
    print('[Item] Storing to inventory: ', filename, ' - ', name)

    var item = InventoryItem.new()
    item.scene_path = filename
    item.name = name
    item.usages = usages
    item.multiple_uses = multiple_uses

    store_custom(item)
    inventory.items.append(item)

"""
Store custom information, this should be extended by items if they need
to store custom information

Should be used in combination with "restore_additional"
"""
func store_custom(item_object: InventoryItem):
    pass
    
"""
Store entity (savegame)
"""
func store_savedata():
    return {
        'position': position,
    }

"""
Restore entity (savegame)
"""
func restore_savedata(data):
    position = data.position
