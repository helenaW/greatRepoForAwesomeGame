extends Control

onready var player = $".."
onready var shown_items = $shown_items

var keymap

var items = []
var active_index = null

var visible_for = 0

func _ready():
    set_process(true)
    if player:
        keymap = player.keymap
    

func get_item_in_use():
    if active_index != null and active_index < items.size():
        return items[active_index]
    return null

func get_item_by_name(item_name):
    for item in items:
        if item.name == item_name:
            return item
    return null
    
func remove_item_by_name(item_name):
    print('[Inventory] Remove item: ', item_name)
    var item = get_item_by_name(item_name)
    if item != null:
        var item_index = items.find(item)
        
        # If we are deleting active item, then we need to set active_index to null
        if item_index == active_index:
            active_index = null
        
        items.erase(item)
        _refresh_shown_items()
        
func set_inventory_items(new_items):
    items = new_items
    _refresh_shown_items()
    
func set_selected_item(index):
    active_index = index
    _refresh_shown_items()
        
func _refresh_shown_items():
    if !items.empty():
        if active_index == null or active_index >= items.size()-1:
            active_index = 0
        else:
            active_index += 1
    
    for i in range(3):
        if shown_items.get_child_count() > 0:
            var child = shown_items.get_child(0)
            shown_items.remove_child(child)
            child.queue_free()
    
    if items.size() > 0:
        # we present 3 items, middle one is "active_index"
        for i in range(-1,2):
            var index = active_index + i
            
            # wrap-around check
            if index < 0:
                index = items.size()-1
            if index >= items.size():
                index = 0
            
            var item_instance = items[index].create_instance()
            var item_sprite = item_instance.get_child(0).duplicate()
            item_sprite.position = Vector2(16, (1+i)*32)
            shown_items.add_child(item_sprite)
            item_instance.queue_free()
        
    player.set_active_item(get_item_in_use())

func _process(delta):
    var keymap_name = player.get_keymap_name(keymap)
    
    # If we picked up an item, we set it as active
    if items.size() != 0 and active_index == null:
        active_index = 0
        player.set_active_item(get_item_in_use())

    if Input.is_action_just_pressed(keymap_name + "_inventory"):
        if items.size() != 0:
            _refresh_shown_items()
            visible = true
            visible_for = 0.55
        else:
            active_index = null
    
    if visible_for > 0:
        visible_for -= delta
    if visible and visible_for <= 0:
        visible = false
        
        
    
    
        
