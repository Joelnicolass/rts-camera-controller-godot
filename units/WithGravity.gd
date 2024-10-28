class_name WithGravity extends Node

@onready var body: CharacterBody3D = get_parent()

var gravity = 9.8

func _physics_process(_delta: float) -> void:
	
	if body.is_on_floor():
		body.velocity.y = 0
	else:
		body.velocity.y -= gravity * get_physics_process_delta_time()
	
	body.move_and_slide()