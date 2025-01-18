extends CharacterBody2D


var speed = 300.0



func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("down"):
		velocity.y += speed
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	
	move_and_slide()

func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
