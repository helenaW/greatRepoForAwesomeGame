extends VBoxContainer

onready var master_volume_slider = $sound_controll/master_volume_slider
onready var effects_volume_slider = $sound_controll/effects_volume_slider
onready var ambient_volume_slider = $sound_controll/ambient_volume_slider

onready var resolution = $screen_controll/resolution_button
onready var fullscreen = $screen_controll/fullscreen_button

onready var unsaved_changes_dialog = $unsaved_changes_dialog

# Was any of the values changed
var dirty = false

var RESOLUTIONS = [
    Vector2(1600, 900),
    Vector2(1920, 1080),
    Vector2(1920, 1200),
]

func _ready():
    load_settings()

func load_settings():
    master_volume_slider.value = settings.settings_data.master_volume
    effects_volume_slider.value = settings.settings_data.effects_volume
    ambient_volume_slider.value = settings.settings_data.ambient_volume
    
    resolution.items = []
    for res in RESOLUTIONS:
        print(res, RESOLUTIONS.find(res))
        resolution.add_item(str(res.x) + ' x ' + str(res.y), RESOLUTIONS.find(res))
    
    resolution.selected = RESOLUTIONS.find(settings.settings_data.resolution)
    fullscreen.pressed = settings.settings_data.fullscreen

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
    get_parent().close_settings_menu()

func _on_save_pressed():    
    settings.settings_data.master_volume = master_volume_slider.value 
    settings.settings_data.effects_volume = effects_volume_slider.value
    settings.settings_data.ambient_volume = ambient_volume_slider.value
    
    settings.settings_data.resolution = RESOLUTIONS[resolution.get_selected_id()]
    settings.settings_data.fullscreen = fullscreen.pressed
    
    settings.apply_settings()
    settings.write_settings()
    
    dirty = false


func _on_reset_pressed():
    settings.delete_settings()
    load_settings()
