extends StaticBody2D
@onready var icesound: AudioStreamPlayer2D = $icesound
@export  var freezemul = 1


var is_up = false

func _ready():
	$icesound.play()

func _on_animation_finished() -> void:
	if is_up:
		queue_free()
	
	$Animation.animation = "static"
	

	var has_frozen_body = false
	var mul = 0
	for body in $IcingZone.get_overlapping_bodies():
		if body.is_class("CharacterBody2D"):
			if body.is_player:
				mul += freezemul	
				body.freeze()
				has_frozen_body = true
	Globals.scoremul += mul
	if has_frozen_body:
		$Animation.play("static")
		$Animation.speed_scale=4
	else:
		$Melt.start(8)
	
				
	$hitbox.disabled = false
	is_up = true
	

func _on_melt_timeout() -> void:
	$Animation.play("static")
	
