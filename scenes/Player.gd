extends KinematicBody2D

export (int) var speed = 200  # How fast the player will move (pixels/sec).

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    var motion = Vector2()
    
    if Input.is_action_pressed("ui_up"):
        motion += Vector2(0, -1)
    if Input.is_action_pressed("ui_down"):
        motion += Vector2(0, 1)
    if Input.is_action_pressed("ui_left"):
        motion += Vector2(-1, 0)
    if Input.is_action_pressed("ui_right"):
        motion += Vector2(1, 0)
    
    motion = motion.normalized() * speed

    move_and_slide(motion)
