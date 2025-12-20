extends Area2D

func _ready():
	print("spawned")

func _on_body_entered(body):
	body.seagrassed()	
