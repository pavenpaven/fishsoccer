extends StaticBody2D

signal goal

func _on_entered(body):
	if body.is_class("CharacterBody2D"):
		if  body.is_ball:
			if body.is_fake:
				body._on_death_timer_timeout()
			else:
				goal.emit()
