extends "res://engine/entity.gd"


const SPEED = 70
const TYPE = "PLAYER"
var state = "default"

var keys = 0

enum keymaps {
    wasd,
    arrows,
}

export (keymaps) var keymap = keymaps.arrows

func _physics_process(delta):
    match state:
        "default":
            state_default()
        "swing":
            state_swing()
    keys = min(keys, 9)
    
    
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
        
    if Input.is_action_just_pressed("wasd_sword"):
        use_item(preload("res://items/sword.tscn"))

func state_swing():
    anim_switch("idle")
    movement_loop()
    damage_loop()
    movedir = dir.center

func controls_loop():
    var keymap_name = 'ui'
    if keymap == keymaps.wasd:
        keymap_name = 'wasd'

    var LEFT = Input.is_action_pressed(keymap_name + "_left")
    var RIGHT = Input.is_action_pressed(keymap_name + "_right")
    var UP = Input.is_action_pressed(keymap_name + "_up")
    var DOWN = Input.is_action_pressed(keymap_name + "_down")
    
    movedir.x = -int(LEFT) + int(RIGHT)
    movedir.y = -int(UP) + int(DOWN)
