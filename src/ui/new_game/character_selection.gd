extends VBoxContainer

var player_f1 = preload("res://characters/playerf1.png")
var player_f2 = preload("res://characters/playerf2.png")
var player_m1 = preload("res://characters/playerm1.png")
var player_m2 = preload("res://characters/playerm2.png")

onready var player_one_picker = $picker/player_one/characters
onready var player_two_picker = $picker/player_two/characters

onready var start_game_button = $start_game

var player_one_selected = false
var player_two_selected = false

func _ready():
    player_one_picker.add_item("Female 1", player_f1)
    player_two_picker.add_item("Female 2", player_f2)
    player_one_picker.add_item("Male 1", player_m1)
    player_two_picker.add_item("Male 2", player_m2)


func _on_player_one_character_selected(index):
    player_one_selected = true
    check_if_ready_to_start_game()


func _on_player_two_character_selected(index):
    player_two_selected = true
    check_if_ready_to_start_game()


func check_if_ready_to_start_game():
    if player_one_selected and player_two_selected:
        start_game_button.disabled = false


func id_to_name(character: String, id: int) -> String:
    if character == 'one':
        if id == 0:
            return 'playerf1'
        if id == 1:
            return 'playerm1'

    if character == 'two':
        if id == 0:
            return 'playerf2'
        if id == 1:
            return 'playerm2'

    return 'unknown_player'


func _on_start_game_pressed():
    save_game.delete_savegame()

    save_game.set_player_one_character(id_to_name('one', player_one_picker.get_selected_items()[0]))
    save_game.set_player_two_character(id_to_name('two', player_two_picker.get_selected_items()[0]))

    save_game.write_savegame()

    get_tree().change_scene("res://main.tscn")
