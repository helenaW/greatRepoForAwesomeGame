extends KinematicBody2D

const MAXHEALTH = 2
const SPEED = 0
const TYPE = 'enemy'

var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

var hitstun = 0
var health = MAXHEALTH
var sprite_default = null
var sprite_hurt = null

func _ready():
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

func damage(value, from_direction):
    if hitstun == 0:
        health -= value
        hitstun = 10
        knockdir = global_transform.origin - from_direction
        
func spritedir_to_vector():
    match spritedir:
        'left': return Vector2(-1,0)
        'right': return Vector2(1,0)
        'up': return Vector2(0,-1)
        'down': return Vector2(0,1)
    
func get_facing_areas():
    $facing_hitbox.global_transform = global_transform.translated(spritedir_to_vector() * 32)
    return $facing_hitbox.get_overlapping_areas()