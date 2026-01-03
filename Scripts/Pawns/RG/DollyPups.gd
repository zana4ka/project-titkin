@tool
extends RGPawn2D

func _ready() -> void:
	
	super()
	
	var bt_player := find_child("BTPlayer") as BTPlayer
	bt_player.blackboard.set_var(&"patrol_center", global_position)
