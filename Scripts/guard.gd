extends CharacterBody2D

var direction
const speed = 200 
var health = 30
var distance_to_player: int = 50
var despawn_range: int = 3000


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var player: CharacterBody2D
@onready var nav_agent = $NavigationAgent2D

func _ready() -> void:
	player = find_player_character()

func _physics_process(_delta: float) -> void:
	direction = to_local(nav_agent.target_position).normalized()
	velocity = direction * speed
	distance_to_player = global_position.distance_to(player.global_position)
	move_and_slide()
	
	if distance_to_player >= despawn_range:
		print("DIAG: A guard has despawned due to distance.")
		queue_free()

func makepath():
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()


func _on_damage_zone_area_entered(area):
	if area.name == "Attack Hitbox":
		health -= 10
		print(health)
	if health <= 0:
		queue_free()


func find_player_character() -> CharacterBody2D:
	return get_tree().get_nodes_in_group("player")[0]

	#Function ran when the Villager moves. Gather direction based on it's direction, and change animation based on that.
func animate():
	# Why did I use vectors? I don't know. I hate Vectors.
	# Values for what direction the villager's sprite should be facing.
	#var facing_up = Vector2(0, -0.5) # No 'up' direction used
	var facing_down = Vector2(0, 0.5)
	var facing_left = Vector2(-0.5, 0)
	var facing_right = Vector2(0.5, 0)
	
	if direction.y > facing_down.y:
		animated_sprite.animation = "FrontView"
		animated_sprite.play()
	elif direction.x < facing_left.x:
		animated_sprite.animation = "SideView"
		animated_sprite.flip_h = true
		animated_sprite.play()
	elif direction.x > facing_right.x:
		animated_sprite.animation = "SideView"
		animated_sprite.play()
		animated_sprite.flip_h = false
