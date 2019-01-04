extends Control

onready var player = $".."


func health_to_color(health, max_health):
    var health_percentage = health * 1.0/max_health
    
    # Green
    if health_percentage > 0.7:
        return Color("#17A733")
    
    # Yellow
    if health_percentage > 0.3:
        return Color("#FFD019")

    # Red
    return Color("#9E1D07")

func _draw():
    if player.health != player.MAXHEALTH:
        draw_circle(Vector2(2.5,2.5), 5, health_to_color(player.health, player.MAXHEALTH))



func _on_player_health_changed():
    update()
