extends Node

"""
Called by main.gd when level is ready to start
"""
func start_level(player_1, player_2):
    player_1.position = $player_1_pos.position
    player_2.position = $player_2_pos.position
