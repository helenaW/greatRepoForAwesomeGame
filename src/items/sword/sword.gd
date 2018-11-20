extends "res://items/item.gd"


export (int) var damage = 1

func use(player):
    $anim.play(str("swing", player.spritedir))
    
    for area in $hitbox.get_overlapping_areas():
        var body = area.get_parent()
        if body.get('TYPE') == 'enemy':
            body.damage(damage, global_transform.origin)