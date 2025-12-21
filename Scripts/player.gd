class_name FotballPlayer extends CharacterBody2D
@onready var fishfall: AudioStreamPlayer2D = $fishfall
@export var accel     = 500
@export var bouncecol = 1.5
@export var drag      = 0.7
@export var falldowndrag = 1
@export var kickpower = 100.0
@export var pushpower = 0.5
@export var seagrassstun = 2.0
@export var unprecissionshot = 100.0
@export var isorange         = true
@export var aitan            = 1
@export var behindball       = 20
@export var sideball         = 200
@export var aidebug			 = false
@onready var soundtimer: Timer = $soundtimer

var is_player = true
var is_ball   = false
var animation = null
var is_down = false
var timer = null
var collision = true


func sigmoid(x):
	var a = ((exp(x)/(exp(x) + 1)) - 0.5)*2
	print(x, "  :  ",a)
	return a

func seagrassed():
	if not is_down:
		$soundtimer.start(0.3)
	if isorange:
		animation.animation = "ofall"
	else:
		animation.animation = "pfall"
	is_down = true
	timer.start(seagrassstun/Globals.physics_speed)
	print("sea")
	
	
		
		
func _ready():
	animation = get_node("animation")
	isorange = not isorange
	if not isorange:
		animation.animation = "pdefault"
	timer = $Timer	
	

func rot(v):
	return Vector2(-v.y, v.x)
	
func ai_move_dir():	
	var center = position #+ Vector2(16, 16)
	var target
	if isorange:
		target = Globals.ogoal
	else:
		target = Globals.pgoal

	var dir = (target - Globals.ball_pos).normalized()

	var xalg = rot(dir).dot(center - Globals.ball_pos)
	var yalg = dir.dot(center - Globals.ball_pos)

	if xalg == 0:
		return Vector2(0,0)

	var prop = yalg / abs(xalg)

	if prop < -aitan: # this case is when player is behind ball
		if aidebug:
			animation.animation="odefault"
		return Globals.ball_pos - center
	elif prop > aitan:  # this cas is when player is infront of ball
		if aidebug:
			animation.animation="pdefault"
		return (Globals.ball_pos + rot(dir) * sign(xalg) * sideball - center)
	else: # this case is when player is beside the ball
		if aidebug:
			animation.animation="placeholder"
		return (Globals.ball_pos - behindball*dir.normalized() - center)

func ai_kick():
	var target
	if isorange:
		target = Globals.ogoal
	else:
		target = Globals.pgoal
	var b = Globals.ball_pos
	return (target - position).normalized()*kickpower*(sigmoid(abs(velocity.normalized().dot(velocity - b))/100)*3 + 1)
	#return velocity.normalized()*(velocity.normalized().dot(velocity - b)) * kickpower
	
func _physics_process(delta):
	if not is_down:
		velocity += ai_move_dir().normalized() * accel * delta * Globals.physics_speed
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
			if collision_info.get_collider().is_ball:
				collision_info.get_collider().on_kicked(ai_kick())
			elif collision_info.get_collider().is_player:
				collision_info.get_collider().velocity += velocity.normalized()*(velocity.normalized().dot(velocity - b)) * pushpower
		velocity = velocity.bounce(collision_info.get_normal()) / bouncecol


func _on_timer_timeout() -> void:
	is_down = false
	if isorange:
		animation.play("odefault")
	else:
		animation.play("pdefault")


func _on_soundtimer_timeout() -> void:
	$fishfall.play()
	print("wawa")
