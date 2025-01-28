extends CharacterBody2D

var rng = RandomNumberGenerator.new() # Used to get a new RNG seed. Still somewhat unsure if this is the best use case.
const SPEED = 100
var decel: float = 20
var runspeed = 1
var direction: Vector2 = Vector2.ZERO
var distance_to_player: int = 50
var detection_range: int = 350
var health = 100
var despawn_range = 2500

var bloodtype: int = 0

@export var player: Node2D
#@onready var player: CharacterBody2D = %Player
@export var despawn_radius: float = 2500


#region About
## Villager
#Planned on making this guy choose a random direction, and then "shunt" himself in that direction.
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize() #Gets a new seed, just for this little guy.
	bloodtype = generate_blood_type()
	identify_blood_type()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, decel * delta)
	if velocity.length() < 1:
		velocity = Vector2.ZERO
		
	distance_to_player = global_position.distance_to(player.global_position)
	if health != 100:
		if distance_to_player <= detection_range:
			var direction = (global_position - player.global_position).normalized()
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
	
	#If the player has decided this villager is undesirable, they can run away, and the villager will despawn.
	if distance_to_player >= despawn_range:
		print("DIAG: A villager has despawned due to distance.")
		queue_free()
	
	move_and_slide() #Move/Slide does not exist here? TODO: Resolve. (CharBody2D?)


# Moves the villager in a random direction every 3 seconds.
func _on_timer_timeout() -> void:
	print("DIAG: Villager timer ended.")
	change_Direction()
	runspeed = SPEED
	velocity = direction * runspeed


func change_Direction():
	direction = Vector2(rng.randf() * 2 - 1, rng.randf() * 2 - 1).normalized()
	# Normalized makes the angles a little more natural.
	
	
func generate_blood_type():
	## Different blood types do different things.
	## Each blood type could increase the value by 3%, but decrease it by 1%?
	# S + / - Speed
	# L + / - Lunge Distance
	# H + / - Max Health 
	# B + / - Blood gained from kill
	# D + / - Max Damage (Should never be able to kill a villager in one hit.
	var random = rng.randi_range(0, 9)
	var better_chances = rng.randi_range(0, 4)
	if better_chances < 3 and random > 5: #If we have a negative, re-roll a positive.
		random -= 5
	return(random)

# This will allow the game to show what blood type the villager has. This will allow the player to pick and choose their victims.
func identify_blood_type():
	if bloodtype == 0:
		$Label.text = "S+"
	elif bloodtype == 1:
		$Label.text = "L+"
	elif bloodtype == 2:
		$Label.text = "H+"
	elif bloodtype == 3:
		$Label.text = "B+"
	elif bloodtype == 4:
		$Label.text = "D+"
	elif bloodtype == 5:
		$Label.text = "S-"
	elif bloodtype == 6:
		$Label.text = "L-"
	elif bloodtype == 7:
		$Label.text = "H-"
	elif bloodtype == 8:
		$Label.text = "B-"
	elif bloodtype == 9:
		$Label.text = "D-"

func take_damage(dmg):
	identify_blood_type()
	health -= dmg
	if health > 1:
		print("Villager is ded!")
		kill()
	else:
		return

# Function for when the player drinks this character's blood. Enemies should also have this.
# This returns the amount of blood the villager had, which is 80% of their current health
# This should be called in conjunction with get_blood_type. (After, obviously)
func draw_blood():
	return (health * 0.8)
	print("Villager is dead!")
	kill()

func _get_blood_type():
	return bloodtype

func kill():
	#Anim info for death.
	#await logic.
	queue_free()
