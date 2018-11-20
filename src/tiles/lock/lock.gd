extends Node2D

signal unlocked

onready var key = $key

var key_name = null

func _ready():
    key_name = key.name

"""
TODO: Maybe it would be good to move this to key instead. But so that key has to be
"used" to unlock the lock. Then lock is informed that is unlocked.

This would mean that all the "unlocking" logic is moved to the key.
"""
func _on_lock_body_entered(body):
    if body.name == "player_1" || body.name == "player_2":
        if body.inventory.get_item_by_name(key_name) != null:
            print('[Lock] Unlocked')
            body.inventory.remove_item_by_name(key_name)
            emit_signal('unlocked')
            
