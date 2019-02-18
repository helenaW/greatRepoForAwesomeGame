extends VBoxContainer

onready var load_game_button = $load_game

var new_game_scene = preload("res://ui/new_game/character_selection.tscn")

func _on_new_game_pressed():
    get_tree().change_scene_to(new_game_scene)


func _on_load_game_pressed():
    get_tree().change_scene("res://main.tscn")


func _on_exit_pressed():
    get_tree().quit()
