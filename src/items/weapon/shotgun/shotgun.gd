extends "res://items/weapon/weapon.gd"

func use(player):
    if not projectile:
        print('[Weapon] NO PROJECTILE: ', name)
        return
        
    for angle in [-PI/3, -PI/6, 0, PI/6, PI/3]:
        var new_projectile = projectile.duplicate(Node.DUPLICATE_USE_INSTANCING)
        
        var direction = player.spritedir_to_vector()
        var distance_from_me = 32 #need to best adjusted by you
        
        match direction:
            Vector2(0, -1):
                # up
                if angle < 0:
                    angle = abs(angle)
                elif angle > 0:
                    angle = -angle
            Vector2(-1, 0):
                print('left')
                if angle < 0:
                    angle -= PI
                elif angle > 0:
                    angle += PI
    
        print(angle)
        
        var angle_transofrmation = Transform2D().rotated(angle)
        
        new_projectile.global_position = global_position + direction * distance_from_me
        new_projectile.shoot(angle_transofrmation * direction)
        
        utils.get_level_node().add_child(new_projectile) 