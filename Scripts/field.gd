extends Node2D

@export var dot_dist = 30
@export var countdown_length = 60
@export var expb             = 0.97
@export var goaldiffmul      = 0.5
@onready var countdown : Timer = $countdown
@onready var orange_scoreboard : Label = $OrangeScore
@onready var purple_scoreboard : Label = $PurpleScore
@onready var timedisplay : Label = $Time
@onready var scoreboard  : Label = $Score

var dots = []
var dragging_from = null
var legal  = false
var orange_goals = 0
var purple_goals = 0

func _ready():
	print("ready")
	Globals.scoremul = 1
	Globals.score = 0
	for i in range(30):
		var dot = load("res://Scenes/dot.tscn").instantiate()
		dot.frame = i % 3
		add_child(dot)
		dots.append(dot)


func spawn_seagrass(pos):
	var scene = load("res://Scenes/seagrass.tscn")
	var instance = scene.instantiate()		
	add_child(instance)
	instance.position = pos


func spawn_decoy(pos):
	var scene = load("res://Scenes/ball.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	instance.position = pos
	instance.is_fake = true
	instance.get_node("AnimatedSprite2D").animation = "decoy"
	instance.get_node("DeathTimer").start(instance.lifespan)

func spawn_ice(pos):
	var scene = load("res://Scenes/iceblock.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	instance.position = pos

func throw(pos):
	if not legal:
		return null

	var type = dragging_from.type
	if type == 0:
		spawn_seagrass(pos)
	if type == 1:
		spawn_ice(pos)
	if type == 2:
		spawn_decoy(pos)
	
	dragging_from.throw()   	
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			for i in get_children():
				if i.is_class("Area2D") and i.get("is_thrower"):
					if i.mouse_inside and i.active:
						dragging_from = i

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging_from:
			throw((get_viewport().get_mouse_position() + Vector2(90, -90)) / 1.7)

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging_from = false
		
	undraw_arrow()
	if dragging_from:
		draw_arrow((get_viewport().get_mouse_position() + Vector2(90, -90))/1.7, dragging_from.position + Vector2(20,20))

func _process(delta):
	print(Globals.scoremul)
	if countdown.time_left==0.0:
		timedisplay.text = "OT"
	else:
		timedisplay.text = str(int(ceil(countdown.time_left)))

func undraw_arrow():
	for i in dots:
		i.position  = Vector2(0,0)
	$Arrow.position = Vector2(0,0)
	$BadArrow.position = Vector2(0,0)

func draw_arrow(p, q):
	var a = p - q
	var num = floor(sqrt(a.dot(a)) / dot_dist)
	for i in range(num):
		dots[i].position = (dot_dist * (i + 1) * a.normalized()) + q
	if legal:
		$Arrow.position = p - a.normalized()*10
		$Arrow.rotation = atan(a.y/a.x) - 3.14/2 + 3.14
	else:
		$BadArrow.position = p - a.normalized()*10
		
			
func reload():
	if countdown.time_left == 0.0:
		countdown.start(countdown_length)
	else:
		if orange_goals == purple_goals:
			countdown.stop()
	
	for i in Globals.balls:
		if not i.is_fake:
			i.position = Vector2(280, 160)
			i.velocity = Vector2(0,0)
			

func _on_purple_goal_goal() -> void:
	purple_goals += 1
	purple_scoreboard.text = str(purple_goals)
	reload()


func _on_orange_goal_goal() -> void:
	orange_goals += 1
	orange_scoreboard.text = str(orange_goals)
	reload()


func _on_item_spawner_cycle():
	var throwers = []
	for i in get_children():
		if i.get("is_thrower") and not i.active:
			throwers.append(i)

	if not throwers:
		return null

	throwers[randi() % len(throwers)].activate()


func _on_mouse_entered_placezone() -> void:
	legal = true

func _on_mouse_exited_placezone() -> void:
	legal = false


func _on_countdown_timeout() -> void:
	Globals.high_score = max(Globals.high_score, Globals.score)
	Globals.physics_speed = 0.4
	get_tree().change_scene_to_file("res://Scenes/deathscreen.tscn")


func _on_scoretimer_cycle() -> void:
	var scoremul = Globals.scoremul
	Globals.score += ceil(10*scoremul * (1 + abs(orange_goals - purple_goals)))
	scoreboard.text = str(int(Globals.score))
	Globals.scoremul = (scoremul - 1)*expb + 1
	
func _on_speedtimer_timeout() -> void:
	Globals.physics_speed += 0.1
	countdown_length = ceil(0.8*countdown_length)
