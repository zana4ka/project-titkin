@tool
extends SceneSpawner2D
class_name TitkinSceneSpawner2D

@export_category("Trigger")
@export var trigger_area: Area2D

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		if not trigger_area: trigger_area = find_child("*rigger*rea*") as Area2D
	else:
		trigger_area.area_entered.connect(_on_trigger_area_target_entered)
		trigger_area.body_entered.connect(_on_trigger_area_target_entered)

func _on_trigger_area_target_entered(in_target: Node2D) -> void:
	try_spawn()
