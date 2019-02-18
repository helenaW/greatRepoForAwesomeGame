extends VBoxContainer

var new_game_scene = preload("res://ui/new_game/character_selection.tscn")

onready var main = get_node('/root/main')

func show():
    get_tree().paused = true
    visible = true


func _on_continue_pressed():
    visible = false
    get_tree().paused = false


func _on_exit_pressed():
    get_tree().quit()


func _on_new_game_pressed():
    get_tree().change_scene_to(new_game_scene)
    get_tree().paused = false


func _on_load_game_pressed():
    get_tree().change_scene("res://main.tscn")
    get_tree().paused = false


func _on_save_game_pressed():
    main.store_savedata()