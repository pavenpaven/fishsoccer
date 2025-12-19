extends CharacterBody2D


func _physics_process(delta):
	velocity += (Vector2(1000,1000) - position).normalized()

	var collision_info = move_and_collide(velocity*delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	
