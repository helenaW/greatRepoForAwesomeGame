extends KinematicBody2D

enum keymaps {
    wasd,
    arrows,
}

export (int) var speed = 70
export (keymaps) var keymap = keymaps.arrows


var movedir = Vector2(0,0)

func _physics_process(delta):
    controls_loop()
    movement_loop()

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
    
func movement_loop():
    var motion = movedir.normalized() * speed
    move_and_slide(motion, Vector2(0,0))
