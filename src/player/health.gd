extends Control

onready var player = $".."

const green = Color("#17A733")
const yellow = Color("#FFD019")
const red = Color("#9E1D07")

func health_to_color(health, max_health):
    var health_percentage = health * 1.0/max_health
    
    # Green
    if health_percentage > 0.7:
        return green.linear_interpolate(yellow, 1-health_percentage)
    
    # Yellow
    if health_percentage > 0.3:
        return yellow.linear_interpolate(red, 1-health_percentage)

    # Red
    return red

func _draw():
    if player.health != player.MAXHEALTH:
        draw_circle(Vector2(2.5,2.5), 5, health_to_color(player.health, player.MAXHEALTH))

func _on_player_health_changed():
    update()
