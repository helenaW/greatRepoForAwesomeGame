extends Control

onready var main = get_node('/root/main')

func _on_save_game_pressed():
    main.store_savedata()
    save_game.write_savegame()

func _on_new_game_pressed():
    save_game.delete_savegame()
    main.load_from_savedata(save_game.load_savegame())    


func _on_load_game_pressed():
    
    main.load_from_savedata(save_game.load_savegame())    
