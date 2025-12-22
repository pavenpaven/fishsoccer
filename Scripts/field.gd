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
	instance.position = pos
	print(instance.position)
	print("added instance")

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

func check_legal(pos):
	return true
	
func throw(pos):
	if not check_legal(pos):
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
			throw((get_viewport().get_mouse_position() + Vector2(65,10)) / 2)

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging_from = false
		
	undraw_arrow()
	if dragging_from:
		draw_arrow((get_viewport().get_mouse_position() + Vector2(65,10))/2, dragging_from.position + Vector2(20,20))

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
	$Arrow.rotation = atan(a.y/a.x) - 3.14/2 + 3.14
			
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


func _on_item_spawner_cycle():
	var throwers = []
	for i in get_children():
		if i.get("is_thrower") and not i.active:
			throwers.append(i)

	if not throwers:
		return null

	throwers[randi() % len(throwers)].activate()
