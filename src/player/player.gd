extends "res://engine/entity.gd"

onready var inventory = $inventory
onready var sprite = $sprite

var state = "default"

enum keymaps {
    wasd,
    arrows,
}

export (keymaps) var keymap = keymaps.arrows

onready var active_item_scene = null

func set_active_item(item):
    if active_item_scene:
        active_item_scene.queue_free()

    if item != null:
        active_item_scene = item.create_instance()
        active_item_scene.scale = Vector2(.5, .5)
        add_child(active_item_scene)
    else:
        active_item_scene = null

func get_keymap_name(keymap):
    match keymap:
        keymaps.wasd: return 'wasd'
        keymaps.arrows: return 'arrows'
        _: return null

func _physics_process(delta):
    match state:
        "default":
            state_default()
        "swing":
            state_swing()
    
func state_default():
    controls_loop()
    movement_loop()
    spritedir_loop()
    damage_loop()
    
    if is_on_wall():
        if spritedir == "left" and test_move(transform , Vector2(-1,0)):
            anim_switch("push")
        if spritedir == "right" and test_move(transform , Vector2(1,0)):
            anim_switch("push")
        if spritedir == "up" and test_move(transform , Vector2(0,-1)):
            anim_switch("push")
        if spritedir == "down" and test_move(transform , Vector2(0,1)):
            anim_switch("push")

    elif movedir != Vector2(0,0):
        anim_switch("walk")
    else:
        anim_switch("idle")

    if Input.is_action_just_pressed(get_keymap_name(keymap) + "_use"):
        var item_in_use = inventory.get_item_in_use()
        if item_in_use != null:
            item_in_use.use(self, active_item_scene)

func state_swing():
    anim_switch("idle")
    movement_loop()
    damage_loop()
    movedir = dir.center

func controls_loop():
    var keymap_name = get_keymap_name(keymap)

    var LEFT = Input.is_action_pressed(keymap_name + "_left")
    var RIGHT = Input.is_action_pressed(keymap_name + "_right")
    var UP = Input.is_action_pressed(keymap_name + "_up")
    var DOWN = Input.is_action_pressed(keymap_name + "_down")

    movedir.x = -int(LEFT) + int(RIGHT)
    movedir.y = -int(UP) + int(DOWN)

func get_facing_areas():
    # Move facing_hitbox to proper "square"
    $facing_hitbox.global_transform = global_transform.translated(spritedir_to_vector() * 32)
    # Check what are we overlapping
    var overlaping_areas = $facing_hitbox.get_overlapping_areas()

    # Position facing_hitbox back on to entity
    $facing_hitbox.global_transform = global_transform

    # Rerurn what we found that we are overlapping
    return overlaping_areas

"""
Store entity (savegame)
"""
func store_savedata():
    var data = .store_savedata()
    
    var items = []
    for item in inventory.items:
        items.append(item.store_savedata())
    
    data.inventory = {
        'items'        : items,
        'active_index' : inventory.active_index,
    }
    return data

"""
Restore entity (savegame)
"""
func restore_savedata(data):
    .restore_savedata(data)
    
    inventory.active_index = data.inventory.active_index
    
    var items = []
    for item in data.inventory.items:
        items.append(ItemObject.restore_savedata(item))
        
    inventory.set_inventory_items(items)

"""
Clears node to "fresh" state.
Called when save game is restore to "new_game"
"""
func clear_savedata():
    inventory.active_index = null
    inventory.set_inventory_items([])

"""
Called by main.gd after everything is loaded and restored...
"""
func additional_restore():
    match keymap:
        keymaps.arrows:
            sprite.texture = load("res://characters/" + save_game.save_data.player_one_character + "anim.png")
        keymaps.wasd:
            sprite.texture = load("res://characters/" + save_game.save_data.player_two_character + "anim.png")
