extends Area2D
@onready var seagrasssound: AudioStreamPlayer2D = $seagrasssound

func _ready():
	print("spawned")
	$seagrasssound.play()

func _on_body_entered(body):
	body.seagrassed()	
	$seagrasssound.play()

func _on_animation_finish() -> void:
	queue_free()
