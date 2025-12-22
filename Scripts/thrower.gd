extends Area2D


@export  var type = 0
@onready var animation : AnimatedSprite2D = $animation
var mouse_inside = false

func _ready():
	if type==0:
		animation.animation = "idle"
	if type==1:
		animation.animation = "snowladyidle"

func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
