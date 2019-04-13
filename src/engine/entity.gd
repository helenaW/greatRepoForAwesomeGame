extends KinematicBody2D

export (int) var SPEED = 0
export (int) var MAX_HEALTH = 2

var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

var hitstun = 0
var health = 0
var sprite_default = null
var sprite_hurt = null

# Signal that entety changed health
signal health_changed

func _ready():
    health = MAX_HEALTH
    sprite_default = $sprite
    sprite_hurt = $sprite_hurt
    
    sprite_hurt.visible = false

func movement_loop():
    var motion 
    if hitstun == 0:
        motion = movedir.normalized() * SPEED
    else:
        motion = knockdir.normalized() * 125
    move_and_slide(motion, Vector2(0,0))

func spritedir_loop():
    match movedir:
        Vector2(-1,0):
            spritedir = "left" 
        Vector2(1,0):
            spritedir = "right" 
        Vector2(0,-1):
            spritedir = "up" 
        Vector2(0,1):
            spritedir = "down" 
            
func anim_switch(animation):
    var newanim = str(animation, spritedir)
    if $anim.current_animation != newanim:
        $anim.play(newanim)
        
func damage_loop():
    if hitstun > 0:
        hitstun -= 1
        sprite_default.visible = false
        sprite_hurt.visible = true
    else:
        sprite_default.visible = true
        sprite_hurt.visible = false

func damage(value: float, from_direction: Vector2):
    if hitstun == 0:
        health -= value
        hitstun = 10
        knockdir = global_transform.origin - from_direction

        emit_signal("health_changed")
        
func heal(value: float):
    health += value
    
    if health > MAX_HEALTH:
        health = MAX_HEALTH
    
    emit_signal("health_changed")
        
func spritedir_to_vector():
    match spritedir:
        'left': return Vector2(-1,0)
        'right': return Vector2(1,0)
        'up': return Vector2(0,-1)
        'down': return Vector2(0,1)
        _: return Vector2()
    
"""
Store entity

Should be extended by entities if they have custom things to save.
"""
func store_savedata():
    return {
        'health'  : health,
        'position': position,
    }

"""
Restore entity

Should be extended by entities if they have custom things to save.
"""
func restore_savedata(data):
    health = data.health
    position = data.position