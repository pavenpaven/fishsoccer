extends CharacterBody2D

@export var drag = 0.2
var is_player = false
var is_ball   = true

func seagrassed():
	pass

func _ready():
	Globals.ball_pos = position

func _physics_process(delta):
	Globals.ball_pos = position
	
	var collision_info = move_and_collide(velocity*delta)
	velocity = (1 - delta*drag)*velocity
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
