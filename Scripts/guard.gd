extends CharacterBody2D


const speed = 200 

@export var player: Node2D
@onready var nav_agent = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.target_position).normalized()
	velocity = dir * speed
	
	move_and_slide()

func makepath():
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
