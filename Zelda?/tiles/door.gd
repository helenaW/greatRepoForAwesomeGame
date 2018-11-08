extends StaticBody2D

onready var teleport_point = $point

func _ready():
    $area.connect("body_entered", self, "body_entered")

func body_entered(body):
    if (body.name == "player_1" || body.name == "player_2"):
        if teleport_point:
            print('should teleport')
            body.global_position = teleport_point.global_position
        else:
            print('no teleport point found')