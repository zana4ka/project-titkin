@tool
extends RGPawn2D

@export_category("Aim")
@export var aim_offset_delay: float = 1.0
@export var aim_offset_step_degrees: float = 30.0

var aim_offset_timer: Timer

func _ready() -> void:
	
	super()
	
	aim_offset_timer = GameGlobals.spawn_regular_timer_for(self, handle_aim_offset, aim_offset_delay)
	
	aim_direction = Vector2.UP

func handle_aim_offset() -> void:
	
	var bt_player := find_child("BTPlayer") as BTPlayer
	var current_target := bt_player.blackboard.get_var(&"chase_target") as Node2D
	if not current_target:
		return
	
	var direction_to_target := global_position.direction_to(current_target.global_position)
	
	var offset_cross := direction_to_target.cross(aim_direction)
	var offset_step := deg_to_rad(aim_offset_step_degrees)
	
	if offset_cross > 0.2:
		aim_direction = aim_direction.rotated(-offset_step)
	elif offset_cross < -0.2:
		aim_direction = aim_direction.rotated(offset_step)
