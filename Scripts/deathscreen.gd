extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$Score.text = "Score: " + str(int(Globals.score))
	$HighScore.text = "Highscore: " + str(int(Globals.high_score))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	Globals.balls=[]
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
