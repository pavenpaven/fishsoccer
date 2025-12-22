extends StaticBody2D

var is_up = false

func _on_animation_finished() -> void:
	if is_up:
		queue_free()
	$Animation.animation = "static"

	var has_frozen_body = false
	for body in $IcingZone.get_overlapping_bodies():
		if body.is_class("CharacterBody2D"):
			if body.is_player:
				body.freeze()
				has_frozen_body = true
	if has_frozen_body:
		$Animation.play("static")
		$Animation.speed_scale=4
	else:
		$Melt.start(8)
	
				
	$hitbox.disabled = false
	is_up = true
	

func _on_melt_timeout() -> void:
	$Animation.play("static")
