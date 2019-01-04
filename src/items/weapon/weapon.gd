extends "res://items/item.gd"

var projectile

func _ready():
    if has_node('projectile'):
        projectile = $projectile.duplicate(Node.DUPLICATE_USE_INSTANCING)
        $projectile.queue_free()

"""
Should be extended by weapons
"""
func use(player):
    if not projectile:
        print('[Weapon] NO PROJECTILE: ', name)
        return
    
    var new_projectile = projectile.duplicate(Node.DUPLICATE_USE_INSTANCING)
    
    var direction = player.spritedir_to_vector()
    var distance_from_me = 32 #need to best adjusted by you
    
    new_projectile.global_position = global_position + direction * distance_from_me
    new_projectile.shoot(direction)
    
    utils.get_level_node().add_child(new_projectile)


