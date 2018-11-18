extends "res://engine/entity.gd"

onready var inventory = $inventory

const SPEED = 70
const TYPE = 'player'

var state = "default"

enum keymaps {
    wasd,
    arrows,
}

export (keymaps) var keymap = keymaps.arrows

onready var active_item = null

func set_active_item(item):
    if active_item == null:
        active_item = $active_item
    active_item.replace_by(item)
    active_item = item

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
        if active_item:
            use_item(active_item)

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
