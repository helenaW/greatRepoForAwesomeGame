extends Node2D

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
export (bool) var multiple_usages = false
export (int) var usages = 0

"""
Should be used by Area2D to send event on "body_entered",
this way it can be added to inventory if pickable
"""
func add_to_inventory_event(body):
    if pickable and (body.name == "player_1" || body.name =="player_2"):
        var item = self.duplicate(DUPLICATE_SCRIPTS+DUPLICATE_GROUPS)
        item.position = Vector2()
        item.visible = true
        
        body.inventory.items.append(item)
        queue_free()

"""
Should be implemented by each usable item. It dose an action when player uses the item
"""
func use(player):
    print('Tried to use item: ', self)