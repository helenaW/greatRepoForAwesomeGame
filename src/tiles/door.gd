extends StaticBody2D

onready var teleport = $teleport
onready var lock = $lock

func _ready():
    # If lock is child of door, then we use lock as enabler/disabler of teleport
    if lock != null:
        teleport.enabled = false
        lock.connect("unlocked", self, "lock_unlocked")


func lock_unlocked():
    print('unlocked event')
    teleport.enabled = true