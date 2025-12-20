extends Node

func _ready():
	randomize()

var ball_pos : Vector2
var physics_speed = 1

var ogoal = Vector2(555,160)
var pgoal = Vector2(0, 160)
