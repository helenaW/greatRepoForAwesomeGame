extends "res://items/item.gd"

onready var hitbox = $hitbox

export (int) var damage = 1

func use(player):
    $anim.play(str("swing", player.spritedir))
    
    for area in hitbox.get_overlapping_areas():
        var body = area.get_parent()
        
        if body.get('TYPE') == 'enemy':
            print('hit enemy')
            if body.hitstun == 0:
                body.hitstun = 10
                body.health -= damage
                body.knockdir = body.global_transform.origin - global_transform.origin 