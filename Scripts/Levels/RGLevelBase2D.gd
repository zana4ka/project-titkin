@tool
extends LevelBase2D
class_name RGLevelBase2D

@export_category("Bounds")
@export var level_bounds_collision: CollisionShape2D

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(level_bounds_collision)

func set_camera_limits_from_level_bounds(for_player: PlayerController) -> void:
	
	var bounds_center := level_bounds_collision.global_position
	var bounds_extents := (level_bounds_collision.shape as RectangleShape2D).size * 0.5
	for_player._camera.set_camera_limits(bounds_center, bounds_extents)
