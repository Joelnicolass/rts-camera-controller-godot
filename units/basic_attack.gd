class_name BasicAttack extends Node

var character: Node3D
var target_obj: Node3D
var target_pos: Vector3
var follow_timer: Timer

func _ready():
	character = get_parent()
	follow_timer = Timer.new()
	follow_timer.connect("timeout", _on_follow_target)
	add_child(follow_timer)


func execute(obj: Node3D, pos: Vector3) -> void:
	target_obj = obj
	target_pos = pos
	follow_timer.start()


func _on_follow_target():
	target_pos = target_obj.global_position
	character.nav.target_position = target_pos
	print("Following target")