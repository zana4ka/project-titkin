extends Resource
class_name ComboData

@export_category("Info")
@export var combo_name: String = "New Combo"

@export_category("Moves")
@export var combo_moves: Array[String] = [
	"L",
	"H",
	"L",
]

func get_priority() -> int:
	return combo_moves.size()

func can_trigger_from_moves(in_moves: Array[String]) -> bool:
	
	if in_moves.size() < combo_moves.size():
		return false
	
	for sample_index: int in range(-1, -(combo_moves.size() + 1), -1):
		if in_moves[sample_index] != combo_moves[sample_index]:
			return false
	return true
