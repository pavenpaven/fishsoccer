extends CharacterBody2D

@export var accel     = 200
@export var bouncecol = 2.0
@export var drag      = 0.4
@export var kickpower = 1.0
var animation = null

func _ready():
	animation = get_node("animation")

func _physics_process(delta):
	velocity += (Globals.ball_pos - position).normalized() * accel * delta
	velocity = (1 - delta*drag)*velocity
	if (Globals.ball_pos - position).x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

	var collision_info = move_and_collide(velocity*delta)

	if collision_info:
		if collision_info.get_collider().name=="Ball":
			var b = collision_info.get_collider().velocity
			collision_info.get_collider().velocity += velocity.normalized()*(velocity.normalized().dot(velocity - b)) * kickpower
		velocity = velocity.bounce(collision_info.get_normal()) / bouncecol
