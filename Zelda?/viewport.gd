extends Control

onready var player_1_view = get_node("/root/main/split_1")
onready var player_2_view = get_node("/root/main/split_2")

func _ready():
#    update()
    pass
    
func _draw():
    
    var p1_rect = get_rect()
    p1_rect.size.y /= 2
    p1_rect.position = Vector2()
    draw_texture_rect(player_1_view.get_texture(), p1_rect, false)
    #draw_rect(p1_rect, Color(1,0,0))

    var p2_rect = get_rect()
    p2_rect.size.y /= 2
    p2_rect.position = Vector2()
    p2_rect.position.y = p2_rect.size.y
    draw_texture_rect(player_2_view.get_texture(), p2_rect, false)
    #draw_rect(p2_rect, Color(0,1,0))
    
    draw_line(
        Vector2(0, p2_rect.size.y),
        Vector2(p2_rect.size.x, p2_rect.size.y),
        Color(0,0,0),
        10)

