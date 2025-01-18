extends CharacterBody2D

var rng = RandomNumberGenerator.new()
const SPEED = 100
var decel: float = 20
var runspeed = 1
var direction: Vector2 = Vector2.ZERO

#region About
## Villager
#Planned on making this guy choose a random direction, and then "shunt" himself in that direction.
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() #Gets a new seed, just for this little guy.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide() #Move/Slide does not exist here? TODO: Resolve. (CharBody2D?)


# Moves the villager in a random direction every 3 seconds.
func _on_timer_timeout() -> void:
	print("DIAG: Villiger timer ended.")
	change_Direction()
	runspeed = SPEED


	# Changes the Villager's movement to a random direction.
	# We could probably add some logic here that forces the villager to move away from Utarefson
func change_Direction():
	direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	# Normalized makes the angles a little more natural.
