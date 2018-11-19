extends Node2D

signal unlocked

onready var key = $key

var key_name = null

func _ready():
    key_name = key.name

func _on_lock_body_entered(body):
    if body.name == "player_1" || body.name == "player_2":
        if body.inventory.get_item_by_name(key_name) != null:
            print('[Lock] Unlocked')
            body.inventory.remove_item_by_name(key_name)
            emit_signal('unlocked')
            
