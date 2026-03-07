extends Node
class_name InteractSource

static func try_get_from(in_node: Node) -> InteractSource:
	return ModularGlobals.try_get_from(in_node, InteractSource)

signal on_interact_start(in_target: InteractTarget)
signal on_interact_finish(in_target: InteractTarget, in_success: bool)

var selected_target: InteractTarget

func _ready() -> void:
	pass

func _enter_tree() -> void:
	ModularGlobals.init_modular_node(self)

func _exit_tree() -> void:
	ModularGlobals.deinit_modular_node(self)

func update_selected_target() -> void:
	pass

func start_interact_with_selected_target() -> void:
	assert(selected_target)
	selected_target.start_interact(self)
	on_interact_start.emit(selected_target)

func finish_interact_with_selected_target(in_success: bool) -> void:
	
	if is_instance_valid(selected_target):
		selected_target.finish_interact(self, in_success)
		on_interact_finish.emit(selected_target)
	selected_target = null
