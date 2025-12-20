extends CharacterBody2D

@export var drag = 0.2

func _ready():
	Globals.ball_pos = position

func _physics_process(delta):
	Globals.ball_pos = position
	
	var collision_info = move_and_collide(velocity*delta)
	velocity = (1 - delta*drag)*velocity
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
