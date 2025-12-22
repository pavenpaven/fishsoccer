extends CharacterBody2D

@export var drag       = 1.5
var maxspeed   = 1000
@export var lifespan   = 20
@export var is_fake   = false
@export var decoyscoremul = 1
var is_player = false
var is_ball   = true
var collision = true
var ball_id : int
var boundses = [0,0,0,0,0]
var bounds  = 0
@onready var footballsound: AudioStreamPlayer2D = $footballsound

func seagrassed():
	pass

func activate_death_timer():
	$DeathTimer.start(lifespan)

func _ready():
	var id = -1
	if is_fake:
		activate_death_timer()
		$AnimatedSprite2D.animation = "decoy"
	
	for i in Globals.balls:
		id = i.ball_id
	ball_id = id + 1
	Globals.balls.append(self)
	Globals.ball_pos = position

func on_kicked(v):
	velocity += v
	$footballsound.play()

func _physics_process(delta):
	Globals.ball_pos = position
	velocity = velocity.normalized()*min(sqrt(velocity.dot(velocity)), maxspeed)
	
	
	var collision_info = move_and_collide(velocity*delta*Globals.physics_speed)
	velocity = (1 - delta*drag*Globals.physics_speed)*velocity
	
	if collision_info:
		bounds +=1
		if collision_info.get_collider().is_class("StaticBody2D"):
			collision = false
			$Timer.start(0.5)
			
		if collision or not collision_info.get_collider().is_class("CharacterBody2D"):
			velocity = velocity.bounce(collision_info.get_normal())
			$footballsound.play()


func _on_timer_timeout() -> void:
	collision=true


func _on_death_timer_timeout() -> void:
	var balls = Globals.balls
	Globals.balls = []
	for i in balls:
		if i.ball_id != ball_id:
			Globals.balls.append(i)

	queue_free()


func _on_cheatdetect_cycle() -> void:
	boundses.append(bounds)
	boundses.remove_at(0)
	bounds = 0
	var acc = false
	for i in boundses:
		acc = acc or (i < 10)
	if not acc:
		if get_parent().name == "main menu":
			position = Vector2(0, 0)
			velocity = Vector2(0,0)
		else:
			position = Vector2(280, 160)
			velocity = Vector2(0,0)
