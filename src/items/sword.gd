extends "res://items/pickable.gd"

func use(player):
    $anim.play(str("swing", player.spritedir))
