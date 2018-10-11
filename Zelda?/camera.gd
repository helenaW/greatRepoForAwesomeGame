extends Camera2D

var player_1 = null
var player_2 = null

func _physics_process(delta):
    if player_1 and player_2:
        position.x = (player_1.position.x + player_2.position.x) / 2
        position.y = (player_1.position.y + player_2.position.y) / 2
