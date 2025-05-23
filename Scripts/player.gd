extends CharacterBody2D

@onready var charge = $Charge


var speed = 300.0
var can_swing : bool = true


func _physics_process(delta):
	
	charge.value += delta * 10 
	
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
	
	

func swing():
	if can_swing:
		$"Attack Hitbox/CollisionShape2D".disabled = false
		# play animation 
		# disable hitbox
		$"Swing Cooldown".start()
		


func _on_swing_cooldown_timeout():
	can_swing = true
	$"Attack Hitbox/CollisionShape2D".disabled = true
	#remove disable when animiation added


func _input(event):
	if event.is_action_pressed("Charge"):
		charge.value = 0
		charge.visible = true
		speed = 30
	if event.is_action_released("Charge"):
		charge.visible = false
		lunge()
		speed = 300
		
	if Input.is_action_pressed("Attack"):
		swing()


func lunge():
	
	var lunge_speed = charge.value * 2000

	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	velocity = direction * lunge_speed
	
	swing()
	#adding animation will elongate this velocity
	move_and_slide()
