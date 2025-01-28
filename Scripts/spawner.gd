extends Node2D

const VILLAGER_DUDE = preload("res://Scenes/VillagerDude.tscn")
const SOLDIER = preload("res://Scenes/guard.tscn")

@export var spawn_radius: float = 1500
@export var despawn_radius: float = 2500
@export var time_decrease: float = 0.1 #Make the game harder, decrease the spawn rate when the timner fires.

@export var weight_villager: float = 90
@export var weight_soldier: float = 10

@onready var timer: Timer = $Timer
#@onready var player: CharacterBody2D = $"." # Can't use this, use Groups System.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# I'm 2 drinks in, and so much documentation.
func _on_timer_timeout() -> void:
	var spawn_position = get_random_spawn()
	
	# Logic for enemy types here.
	var enemy = get_enemy_type().instantiate()
	
	enemy.global_position = spawn_position
	add_child(enemy)

func get_enemy_type():
	var random = randf_range(1.0, 100.0)
	if random <= weight_villager:
		return VILLAGER_DUDE
	else:
		return SOLDIER

func get_random_spawn() -> Vector2:
	var player_position = get_player().global_position
	
	var angle = randf_range(0, 2 * PI)
	var distance = spawn_radius #Replace with some randomization if needed.
	
	var offset = Vector2(distance, 0).rotated(angle) #Offset is a level of distance away from the player opsition. It can be anywhere in a 360deg angle.
	var spawn_pos = player_position + offset #Spawnpos is when we move the enemy spawn away.
	
	return spawn_pos

func get_player() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("player") # Only 1 player, should work.
