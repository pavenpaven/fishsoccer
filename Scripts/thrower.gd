extends Area2D


@export  var type = 0
@onready var animation : AnimatedSprite2D = $animation
var mouse_inside = false
var active       = false
var is_thrower   = true

func _ready():
	animation.animation = str(type) + "idle"

func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false

func throw():
	active = false
	animation.animation = str(type) + "idle"

func activate():
	active = true
	animation.animation = str(type) + "active"
