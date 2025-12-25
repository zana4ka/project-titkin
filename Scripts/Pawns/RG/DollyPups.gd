@tool
extends RGPawn2D

func _ready() -> void:
	
	super()
	
	bt_player.blackboard.set_var(&"patrol_center", global_position)
