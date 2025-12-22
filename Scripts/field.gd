extends Node2D

@export var dot_dist = 30
var dots = []
var dragging_from = null

func _ready():
	for i in range(30):
		var dot = load("res://Scenes/dot.tscn").instantiate()
		dot.frame = i % 3
		add_child(dot)
		dots.append(dot)


func spawn_seagrass(pos):
	var scene = load("res://Scenes/seagrass.tscn")
	var instance = scene.instantiate()		
	add_child(instance)
	instance.position = (pos + Vector2(65,10)) / 2
	print(instance.position)
	print("added instance")

func _input(event):
	undraw_arrow()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		draw_arrow((get_viewport().get_mouse_position() + Vector2(65,10))/2, Vector2(0,0))
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_seagrass(event.position)

	if event is InputEventKey:
		if event.keycode == KEY_F and event.pressed:
			var pos  = get_viewport().get_mouse_position()
			var scene = load("res://Scenes/ball.tscn")
			var instance = scene.instantiate()
			add_child(instance)
			instance.position = (pos + Vector2(65,10)) / 2
			instance.is_fake = true
			instance.get_node("AnimatedSprite2D").animation = "decoy"
			instance.get_node("DeathTimer").start(instance.lifespan)
		if event.keycode == KEY_I and event.pressed:
			var pos  = get_viewport().get_mouse_position()
			var scene = load("res://Scenes/iceblock.tscn")
			var instance = scene.instantiate()
			add_child(instance)
			instance.position = (pos + Vector2(65,10)) / 2

func undraw_arrow():
	for i in dots:
		i.position  = Vector2(0,0)
	$Arrow.position = Vector2(0,0)

func draw_arrow(p, q):
	var a = p - q
	var num = floor(sqrt(a.dot(a)) / dot_dist)
	for i in range(num):
		dots[i].position = (dot_dist * (i + 1) * a.normalized()) + q
	$Arrow.position = p - a.normalized()*10
	$Arrow.rotation = atan(a.y/a.x) - 3.14/2
			
func reload():
	var balls = Globals.balls
	Globals.balls = []
	for i in balls:
		if not i.is_fake:
			Globals.balls.append(i)
			i.position = Vector2(280, 160)
			i.velocity = Vector2(0,0)

func _on_purple_goal_goal() -> void:
	reload()


func _on_orange_goal_goal() -> void:
	reload()			
