extends CharacterBody2D

@export var drag = 0.2
var is_player = false
var is_ball   = true
var collision = true

func seagrassed():
	pass

func _ready():
	Globals.ball_pos = position

func _physics_process(delta):
	Globals.ball_pos = position
	
	var collision_info = move_and_collide(velocity*delta*Globals.physics_speed)
	velocity = (1 - delta*drag*Globals.physics_speed)*velocity
	
	if collision_info:
		if collision_info.get_collider().is_class("StaticBody2D"):
			collision = false
			$Timer.start(0.5)
			
		if collision or not collision_info.get_collider().is_class("CharacterBody2D"):
			velocity = velocity.bounce(collision_info.get_normal())


func _on_timer_timeout() -> void:
	collision=true
