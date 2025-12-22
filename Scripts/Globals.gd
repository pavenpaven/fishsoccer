extends Node

func _ready():
	randomize()

var scoremul = 1
	
var ball_pos : Vector2
var balls = []
var physics_speed = 0.4

var ogoal = Vector2(555,160)
var pgoal = Vector2(0, 160)
var score = 0

var high_score = 0
