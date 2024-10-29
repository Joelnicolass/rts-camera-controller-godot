class_name BasicAttack extends Node3D

var character: Node3D
var target_obj: Node3D
var target_pos: Vector3
var follow_timer: Timer
@export var auto_attack: bool = true


func _ready():
	UnitEvents.on_command_units.connect(_on_command_units)
	character = get_parent()
	follow_timer = Timer.new()
	follow_timer.connect("timeout", _on_follow_target)
	add_child(follow_timer)


func execute(obj: Node3D, pos: Vector3) -> void:
	if obj.team == Constants.PLAYER_TEAM: return

	target_obj = obj
	target_pos = pos
	follow_timer.start()


func _on_follow_target():
	target_pos = target_obj.global_position
	character.nav.target_position = target_pos
	print("Following target")


func _on_command_units(units: Array, cmd: UnitCommand) -> void:
	if units.has(character) and cmd.type != UnitCommand.Type.ACTION:
		follow_timer.stop()
		target_pos = Vector3.ZERO
		target_obj = null


func _on_distance_body_entered(body: Node3D) -> void:
	if body is Unit and auto_attack and body.team != character.team:
		print('auto attacking')
		execute(body, body.global_position)

	if body == target_obj:
		follow_timer.stop()
		# detener la unidad
		character.nav.target_position = character.global_position
		print("Found target")
		_attack()


func _on_distance_body_exited(body: Node3D) -> void:
	if body == target_obj:
		follow_timer.start()
		print("Lost target")


func _attack() -> void:
	print("Attacking")