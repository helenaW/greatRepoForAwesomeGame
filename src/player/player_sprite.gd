extends Sprite

var texture_1 = preload("res://player/player1.png")
var texture_2 = preload("res://player/player2.png")

onready var player = $".."

func _ready():
    match player.keymap:
        player.keymaps.arrows:
            texture = texture_1
        player.keymaps.wasd:
            texture = texture_2