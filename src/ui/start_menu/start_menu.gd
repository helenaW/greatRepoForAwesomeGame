extends Control

var new_game_scene = preload("res://ui/new_game/character_selection.tscn")

onready var settings_menu = $settings_menu
onready var start_menu = $start_menu

func _on_new_game_pressed():
    get_tree().change_scene_to(new_game_scene)


func _on_load_game_pressed():
    get_tree().change_scene("res://main.tscn")


func _on_exit_pressed():
    get_tree().quit()

func close_settings_menu():
    settings_menu.visible = false
    start_menu.visible = true
    
func open_settings_menu():
    start_menu.visible = false
    settings_menu.visible = true