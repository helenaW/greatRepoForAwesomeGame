extends Node2D

export (bool) var pickable = true

func _on_pickable_body_entered(body):
    if pickable and (body.name == "player_1" || body.name =="player_2"):
        body.inventory.items.append(self.duplicate())
        queue_free()

"""
Should be implemented by each usable item

Should return true/false. True means that we keep it, false means that we destroy it?
"""
func use():
    print('Tried to use item: ', self)
    pass