extends Node2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var scene = load("res://Scenes/seagrass.tscn")
			var instance = scene.instantiate()		
			add_child(instance)
			instance.position = (event.position + Vector2(65,10)) / 2
	if event is InputEventKey:
		if event.keycode == KEY_F and event.pressed:
			var pos  = get_viewport().get_mouse_position()
			var scene = load("res://Scenes/ball.tscn")
			var instance = scene.instantiate()
			add_child(instance)
			instance.position = (pos + Vector2(65,10)) / 2
			instance.is_fake = true
			instance.get_node("AnimatedSprite2D").animation = "decoy"
					
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
