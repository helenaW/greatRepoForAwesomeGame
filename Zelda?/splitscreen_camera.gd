extends Camera2D

var player_target = null

export (float) var speed = 150.0

func _physics_process(delta):
    if player_target:
        position = player_target.position
        