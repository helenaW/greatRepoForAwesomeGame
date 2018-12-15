extends "res://engine/entity.gd"

const SPEED = 40
const DAMAGE = 1

var movetimer_length = 15
var movetimer = 0

func _ready():
    $anim.play("default")
    movedir = dir.rand()
    
func _physics_process(delta):
    movement_loop()
    damage_loop()
    
    if movetimer > 0:
        movetimer -= 1
    if movetimer == 0 || is_on_wall():
        movedir = dir.rand()
        movetimer = movetimer_length

func damage_loop():
    .damage_loop()
    
    if health <= 0:
        var death_animation = preload("res://enemies/enemy_death.tscn").instance()
        get_parent().add_child(death_animation)
        death_animation.global_transform = global_transform
        queue_free()

    for area in $hitbox.get_overlapping_areas():
        var body = area.get_parent()
        body.damage(DAMAGE, global_transform.origin)