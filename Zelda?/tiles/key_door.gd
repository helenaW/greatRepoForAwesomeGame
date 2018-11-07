extends StaticBody2D


func _ready():
    $area.connect("body_entered", self, "body_entered")

func body_entered(body):
    if (body.name == "player_1" || body.name == "player_2")&& body.get("keys")> 0:
        body.keys -=1
        queue_free()
