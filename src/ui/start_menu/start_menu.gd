extends VBoxContainer

onready var load_game_button = $load_game

var new_game_scene = preload("res://ui/start_menu/new_game/character_selection.tscn")


func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass


func _on_new_game_pressed():
    get_tree().change_scene_to(new_game_scene)


func _on_load_game_pressed():
    get_tree().change_scene("res://main.tscn")
