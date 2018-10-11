extends Node

onready var world = $World
onready var player1 = world.get_node('Player 1')
onready var player2 = world.get_node('Player 2')
onready var camera = $Camera


func _ready():
    camera.player_1 = player1
    camera.player_2 = player2
    