extends CharacterBody3D

class_name Unit

const DISTANCE_STOP_THRESHOLD = 0.5

@onready var nav: NavigationAgent3D = %NavAgent

@export var speed = 2
@export var accel = 10
@export var team: int

func _ready() -> void:
	nav.velocity_computed.connect(_on_nav_agent_velocity_computed)

func _physics_process(delta: float) -> void:
	_move_towards_nav_target(delta)

func _move_towards_nav_target(delta: float) -> void:
	var dir = nav.get_next_path_position() - global_position
	
	if nav.is_navigation_finished():
		return
	
	if nav.distance_to_target() >= DISTANCE_STOP_THRESHOLD:
		var target_basis = Basis.looking_at(-dir)
		basis = basis.slerp(target_basis, 0.2)
	
	dir = dir.normalized()
	
	var target_velocity = velocity.lerp(dir * speed, accel * delta)
	nav.velocity = target_velocity

func set_command(command: UnitCommand):
	#if team != Constants.PLAYER_TEAM: return
	
	if command.type == UnitCommand.Type.MOVE:
			nav.target_position = command.target_pos
	if command.type == UnitCommand.Type.ACTION:
		if has_node("Action"):
			get_node("Action").execute(command.target_obj, command.target_pos)

func _on_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	
	move_and_slide()
