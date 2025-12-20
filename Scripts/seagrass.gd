extends Area2D

func _ready():
	print("spawned")

func _on_body_entered(body):
	body.seagrassed()	


func _on_animation_finish() -> void:
	queue_free()
