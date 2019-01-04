extends Node

func get_level_node():
    return get_tree().get_root().get_node("main/view").get_child(0)
