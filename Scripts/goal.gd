extends StaticBody2D

@export var decoyscoremul = 1

signal goal

func _on_entered(body):
	if body.is_class("CharacterBody2D"):
		if  body.is_ball:
			if body.is_fake:
				Globals.scoremul += decoyscoremul
				body._on_death_timer_timeout()
			else:
				goal.emit()
