extends StaticBody2D

onready var teleport = $teleport

var entered_num = 0

func _ready():
    teleport.enabled = false

"""
Example of doors that open after players has a key
"""
func _on_area_body_entered(body):
    if body.name == "player_1" || body.name == "player_2":
        for item in body.inventory.items:
            if item.name == 'key':
                teleport.enabled = true