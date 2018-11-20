extends Node2D

"""
Static representation of Item, used for Inventory system and "will"
be used for representing items when saving/loading data
"""
class ItemObject:
    var scene_path
    var sprite_path
    var name
    var usages
    var multiple_uses
    
    func _init(scene_path, name, usages, multiple_uses):
        self.scene_path = scene_path
        self.name = name
        self.usages = usages
        self.multiple_uses = multiple_uses
    
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
func add_to_inventory_event(body):
    if pickable and (body.name == "player_1" || body.name =="player_2"):
        store(body.inventory)
        queue_free()

"""
Should be implemented by each usable item. It dose an action when player uses the item
"""
func use(player):
    print('[Item] Tried to use item: ', name)

"""
It restores Item to what is saved in inventory
Can be extended by items, if they have some custom properties that need to be restored
"""
func restore(item_object):
    print('[Item] Restoring from item_object: ', name)
    usages = item_object.usages
    multiple_uses = item_object.multiple_uses
    pickable = false # It's not pickable anymore as is in our inventory

"""
It stores current item state to inventory
Can be extended by items, if they have custom properties that need to be saved
"""
func store(inventory):
    print('[Item] Storing to inventory: ', filename, ' - ', name)
    var item_object = ItemObject.new(
        filename,
        name,
        usages,
        multiple_uses)

    inventory.items.append(item_object)