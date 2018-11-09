extends StaticBody2D

onready var teleport = $teleport

var entered_num = 0

func _ready():
    teleport.enabled = false

"""
Example of doors that open after players pressing on them 3 times.
"""
func _on_area_body_entered(body):
    if body.name == "player_1" || body.name == "player_2":
        entered_num += 1
        if entered_num == 3:
            if teleport:
                teleport.enabled = true