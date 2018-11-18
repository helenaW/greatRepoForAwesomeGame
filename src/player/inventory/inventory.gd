extends Control

onready var player = $".."
onready var shown_items = $shown_items

var keymap

var items = []
var selected_item_index = null

var visible_for = 0

func get_item_in_use():
    if selected_item_index != null:
        return items[selected_item_index]
    return null

func _ready():
    set_process(true)
    if player:
        keymap = player.keymap

func _process(delta):
    var keymap_name = player.get_keymap_name(keymap)
    
    # If we picked up an item, we set it as activ e
    if items.size() != 0 and selected_item_index == null:
        selected_item_index = 0
        player.set_active_item(get_item_in_use())

    if Input.is_action_just_pressed(keymap_name + "_inventory"):
        if items.size() != 0:
            if selected_item_index == null or selected_item_index == items.size()-1:
                selected_item_index = 0
            else:
                selected_item_index += 1
            
            shown_items.remove_child(shown_items.get_child(0))
            shown_items.remove_child(shown_items.get_child(1))
            shown_items.remove_child(shown_items.get_child(2))
            
            # we present 3 items, middle one is "selected_item_index"
            for i in range(-1,2):
                var index = selected_item_index + i
                
                if index < 0:
                    index = items.size()-1
                if index == items.size():
                    index = 0
                
                var item = items[index].get_child(0).duplicate()
                item.position = Vector2(16, (1+i)*32)
                shown_items.add_child(item)
                
            player.set_active_item(get_item_in_use())
    
            visible = true
            visible_for = 0.55
        else:
            selected_item_index = null
    
    if visible_for > 0:
        visible_for -= delta
    if visible and visible_for <= 0:
        visible = false
        
        
    
    
        
