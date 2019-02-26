extends RigidBody2D

enum shooters {
    PLAYER,
    ENEMY
}

"""
How long is the projectile allive for in ms
"""
export (int) var alive_for = 2
export (int) var speed = 200
export (int) var damage = 1
export (shooters) var shooter = shooters.PLAYER

var was_shoot = false

func _physics_process(delta):
    
    if was_shoot:
        alive_for -= delta
        if alive_for <= 0:
            queue_free()

func shoot(direction):
    linear_velocity = direction * speed
    was_shoot = true

func _on_hitbox_area_entered(area):
    var body = area.get_parent()
    
    if body.is_in_group('enemy') and shooter == shooters.PLAYER:
        body.damage(damage, global_transform.origin)

    if body.is_in_group('player') and shooter == shooters.ENEMY:
        body.damage(damage, global_transform.origin)

    queue_free()
