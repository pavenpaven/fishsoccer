extends Node

func _ready():
	randomize()

var ball_pos : Vector2
var physics_speed = 0.6

var ogoal = Vector2(555,160)
var pgoal = Vector2(0, 160)
