extends Node2D


@onready var pause_menu = $PauseMenu
var paused : bool = false

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
		
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.position = $Player/Camera2D.get_global_transform().origin
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
