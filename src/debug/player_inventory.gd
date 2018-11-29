extends RichTextLabel

onready var player_1 = get_node("/root/main/view/player_1")
onready var player_2 = get_node("/root/main/view/player_2")

const NEW_LINE = """
"""

func _process(delta):
    text = ""
    
    text += "PLAYER 1:" + NEW_LINE
    text += "position: " + str(player_1.position) + NEW_LINE
    for item in player_1.inventory.items:
        text += " - " + item.name + NEW_LINE
    
    text += "PLAYER 2:" + NEW_LINE
    text += "position: " + str(player_2.position) + NEW_LINE
    for item in player_2.inventory.items:
        text += " - " + item.name + NEW_LINE

