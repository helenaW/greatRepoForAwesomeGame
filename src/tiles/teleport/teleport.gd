extends Area2D

onready var teleport_point = $point
onready var enabled = true

func _on_teleport_body_entered(body):
    if body.name == "player_1" || body.name == "player_2":
        if teleport_point and enabled:
            body.global_position = teleport_point.global_position

