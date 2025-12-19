extends CharacterBody2D

func _physics_process(delta)
  	var collision_info = move_and_collide(velocity*delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	
