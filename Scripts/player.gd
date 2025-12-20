class_name FotballPlayer extends CharacterBody2D

@export var accel     = 500
@export var bouncecol = 1.5
@export var drag      = 1
@export var falldowndrag = 0.4
@export var kickpower = 1.0
@export var seagrassstun = 2.0
@export var unprecissionshot = 30.0
@export var isorange         = true
@export var aitan            = 2
@export var behindball       = 20
var is_player = true
var is_ball   = false
var animation = null
var is_down = false
var timer = null
var collision = true

func seagrassed():
	if isorange:
		animation.animation = "ofall"
	else:
		animation.animation = "pfall"
	is_down = true
	timer.start(seagrassstun/Globals.physics_speed)
	print("sea")

func _ready():
	animation = get_node("animation")
	timer     = $Timer	

func rot(v):
	return Vector2(-v.y, v.x)
	
func ai():	
	var target
	if isorange:
		target = Globals.ogoal
	else:
		target = Globals.pgoal

	var dir = (target - Globals.ball_pos).normalized()

	var xalg = rot(dir).dot(position - Globals.ball_pos)
	var yalg = dir.dot(position - Globals.ball_pos)

	if xalg == 0:
		return Vector2(0,0)

	var prop = yalg / abs(xalg)

	if prop < -aitan: # this case is when player is behind ball
		return Globals.ball_pos - position
	elif prop > aitan:  # this cas is when player is infornt of ball
		return xalg * rot(dir)
	else: # this case is when player is to the front of ball
		return (Globals.ball_pos - behindball*dir.normalized() - position)

func _physics_process(delta):
	if not is_down:
		velocity += ai().normalized() * accel * delta * Globals.physics_speed
	else:
		velocity = (1 - delta*falldowndrag*Globals.physics_speed)*velocity
	velocity = (1 - delta*drag)*velocity
	if (Globals.ball_pos - position).x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

	var collision_info = move_and_collide(velocity*delta*Globals.physics_speed)

	if collision_info:
		if collision_info.get_collider().is_class("CharacterBody2D") and collision:
			var b = collision_info.get_collider().velocity
			collision_info.get_collider().velocity += velocity.normalized()*(velocity.normalized().dot(velocity - b)) * kickpower + Vector2(randfn(-unprecissionshot, unprecissionshot), randfn(-unprecissionshot, unprecissionshot))
		velocity = velocity.bounce(collision_info.get_normal()) / bouncecol


func _on_timer_timeout() -> void:
	is_down = false
	if isorange:
		animation.play("odefault")
	else:
		animation.play("pdefault")
