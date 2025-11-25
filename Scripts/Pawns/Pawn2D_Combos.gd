extends Node
class_name Pawn2D_Combos

@export_category("Variants")
@export var combo_variants: Array[ComboData]

var current_combo_moves: Array[String] = []
var current_combo: ComboData = null:
	set(in_combo):
		current_combo = in_combo
		if current_combo:
			combo_trigger.emit(current_combo)

signal combo_trigger(in_combo_data: ComboData)

func _ready() -> void:
	pass

func add_move(in_move: String) -> void:
	current_combo_moves.append(in_move)
	current_combo = find_best_combo_for_current_moves()

func reset_moves() -> void:
	current_combo_moves.clear()
	current_combo = null

func find_best_combo_for_current_moves() -> ComboData:
	
	var out_combo: ComboData = null
	for sample_combo: ComboData in combo_variants:
		
		if not sample_combo.can_trigger_from_moves(current_combo_moves):
			continue
		
		if (not out_combo) and (sample_combo.get_priority() > sample_combo.get_priority()):
			out_combo = sample_combo
	return out_combo
