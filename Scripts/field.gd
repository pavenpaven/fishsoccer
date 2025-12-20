extends Node2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var scene = load("res://Scenes/seagrass.tscn")
			var instance = scene.instantiate()		
			add_child(instance)
			instance.position = (event.position + Vector2(65,10)) / 2
			print(instance.position)
			print("added instance")
