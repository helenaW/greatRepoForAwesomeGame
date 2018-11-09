extends Control

onready var player = $".."

var keymap

func _ready():
    set_process(true)
    if player:
        keymap = player.keymap


func _process(delta):
    var keymap_name = player.get_keymap_name(keymap)

    print(keymap_name + "_inventory")

    if Input.is_action_just_pressed(keymap_name + "_inventory"):
        visible = !visible
