extends CharacterBody2D

@onready var charge = $Charge

var max_health = 100
var current_health = max_health
var speed = 300.0
var can_swing : bool = true
var can_bite : bool = true

var lunge_buff = 0
var heal = 10
var ap = 10 #attack potentcy 


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
	$Aim.look_at(mouse_position)
	
	

func swing():
	if can_swing:
		$"Aim/Attack Hitbox/CollisionShape2D".disabled = false
		# play animation 
		# disable hitbox
		$"Swing Cooldown".start()
		


func _on_swing_cooldown_timeout():
	can_swing = true
	$"Aim/Attack Hitbox/CollisionShape2D".disabled = true
	#remove disable when animiation added


func _input(event):
	if event.is_action_pressed("Charge"):
		charge.value = 0
		charge.visible = true
		speed = 30
	if event.is_action_released("Charge"):
		charge.visible = false
		var old_speed = speed
		lunge()
		speed = old_speed
		
	if Input.is_action_pressed("Attack"):
		swing()
	
	if Input.is_action_pressed("Bite"):
		bite()


func lunge():
	
	var lunge_speed = (charge.value + lunge_buff) * 2000

	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	velocity = direction * lunge_speed
	
	swing()
	#adding animation will elongate this velocity
	move_and_slide()
	


func _on_hurtbox_area_entered(area):
	if area.name == "Damage Zone":
		current_health -= 10
		if current_health <= 0:
			current_health = max_health
			print("you died")
		print(current_health)
		

func bite():
	if can_bite:
		$"Bite Radius/CollisionShape2D".disabled = false
		can_bite = false
		$"Bite Cooldown".start()
		$"Bite Active Time".start()



func _on_bite_radius_body_entered(body):
	var bloodtype: int 
	if body is CharacterBody2D and body.name == "Villager":
		print("bite")
		bloodtype = body.bloodtype
		if bloodtype == 0:
			speed += 10
		elif bloodtype == 1:
			lunge_buff += 1
		elif bloodtype == 2:
			max_health += 5
			current_health += 5
		elif bloodtype == 3:
			heal += 5
		elif bloodtype == 4:
			ap += 2 
		elif bloodtype == 5:
			speed -= 5
		elif bloodtype == 6:
			lunge_buff -= 1
		elif bloodtype == 7:
			max_health -= 5
			current_health -= 5
		elif bloodtype == 8:
			heal -= 5
		elif bloodtype == 9:
			ap -= 1
		current_health += heal
		if current_health > max_health:
			current_health = max_health
		self.position = body.global_position
		#set speed to 0
		#playbite animation
		#set speed to normal 
		body.queue_free()


func _on_bite_cooldown_timeout():
	can_bite = true


func _on_bite_active_time_timeout():
	$"Bite Radius/CollisionShape2D".disabled = true
