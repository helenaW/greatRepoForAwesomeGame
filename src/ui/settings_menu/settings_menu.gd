extends VBoxContainer

onready var master_volume_slider = $sound_controll/master_volume_slider
onready var effects_volume_slider = $sound_controll/effects_volume_slider
onready var ambient_volume_slider = $sound_controll/ambient_volume_slider

onready var unsaved_changes_dialog = $unsaved_changes_dialog

# Was any of the values changed
var dirty = false

func _ready():
    pass

func _on_any_value_changed(not_used):
    dirty = true

func _on_back_pressed():
    if dirty:
        unsaved_changes_dialog.show()
    else:
        return_to_parent_sceene()


func _on_unsaved_changes_dialog_confirmed():
    return_to_parent_sceene()


func _on_unsaved_changes_dialog_popup_hide():
    pass

func return_to_parent_sceene():
    get_tree().change_scene("res://ui/pause_menu/pause_menu.tscn")