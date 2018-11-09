extends Control

onready var player = $".."
onready var items_list = $items_list_scroll/items_list

var keymap

var items = []

func _ready():
    set_process(true)
    if player:
        keymap = player.keymap


func _process(delta):
    var keymap_name = player.get_keymap_name(keymap)
    
    #for child in $items_list.get_children():
        #$items_list.remove_child(child)
    
    for i in range(items.size()):
        items[i].position = Vector2(0, 32 * i)
        items_list.add_child(items[i])

    if Input.is_action_just_pressed(keymap_name + "_inventory"):
        visible = !visible
