extends Node
class_name InteractTarget

static func try_get_from(in_node: Node) -> InteractTarget:
	return ModularGlobals.try_get_from(in_node, InteractTarget)

signal on_interact_start(in_source: InteractSource)
signal on_interact_finish(in_source: InteractSource, in_success: bool)

func _ready() -> void:
	pass

func _enter_tree() -> void:
	ModularGlobals.init_modular_node(self)

func _exit_tree() -> void:
	ModularGlobals.deinit_modular_node(self)

func start_interact(in_source: InteractSource) -> void:
	on_interact_start.emit(in_source)

func finish_interact(in_source: InteractSource, in_success: bool) -> void:
	on_interact_start.emit(in_source, in_success)
