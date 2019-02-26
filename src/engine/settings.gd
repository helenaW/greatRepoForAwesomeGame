extends Node

signal settings_change

var settings_file = File.new()
var settings_path = "user://settings.json"

var settings_data
var initial_settings_data = {
    'resolution': Vector2(1600, 900),
    'fullscreen': false,
    
    'master_volume': 80,
    'effects_volume': 80,
    'ambient_volume': 80,
   }

func _write_to_file():
    settings_file.open(settings_path, File.WRITE)
    settings_file.store_var(settings_data)
    settings_file.close()

func _read_from_file():
    settings_file.open(settings_path, File.READ)
    settings_data = settings_file.get_var()
    settings_file.close()


"""
Loads settings from settings file
"""
func load_settings():
    if not settings_file.file_exists(settings_path):
        print('[Settings] Loading from disk - NEW')
        initialize_settings()
        _write_to_file()
    else:
        print('[Settings] Loading from disk - EXISTING')
        _read_from_file()
        
    return settings_data
        
"""
Writes settings_data to settings file
"""
func write_settings():
    print('[Settings] Writing to disk')
    _write_to_file()

"""
Writes fresh settings_data to settingsfile
"""
func delete_settings():
    print('[Settings] Deleting from disk')
    initialize_settings()
    _write_to_file()

"""
Initializes settings_data
"""
func initialize_settings():
    print('[Settings] Initializing settings_data')
    settings_data = initial_settings_data.duplicate()
    

func apply_settings():
    print('[Settings] Applying settings_data')
    if settings_data == null:
        load_settings()

    # FIXME: Resolution not working exactly right yet.
    # You have to go out of fullscreen, set resolution and go back in full screen
    # https://github.com/godotengine/godot/issues/14542
    
    OS.window_fullscreen = settings_data.fullscreen
    #OS.window_borderless = settings_data.fullscreen
    OS.window_size = settings_data.resolution

    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), settings_data.master_volume)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), settings_data.effects_volume)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), settings_data.ambient_volume)
    
    emit_signal('settings_change')
    
func _ready():
    apply_settings()
