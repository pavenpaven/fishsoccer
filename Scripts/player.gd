extends CharacterBody2D

@export var accel = 2
@export var bouncecol = 2

func _physics_process(delta):
	velocity += (Globals.ball_pos - position).normalized() * accel

	var collision_info = move_and_collide(velocity*delta)

	if collision_info:
		if collision_info.get_collider().name=="Ball":
			collision_info.get_collider().velocity += velocity.normalized()*(velocity.normalized().dot(velocity) - velocity.normalized().dot(collision_info.get_collider().velocity)) 
		velocity = velocity.bounce(collision_info.get_normal()) / 2
