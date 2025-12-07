extends Node
class_name Pawn2D_SpecialAbility

static func try_get_from(in_node: Node) -> Pawn2D_SpecialAbility:
	return ModularGlobals.try_get_from(in_node, Pawn2D_SpecialAbility)

@export_category("Owner")
@export var owner_pawn: Pawn2D

@export_category("Charge")
@export var charge_per_kill: float = 0.25

var current_charge: float = 0.0:
	set(in_charge):
		current_charge = clampf(in_charge, 0.0, 1.0)
		current_charge_changed.emit()
signal current_charge_changed()

signal activated()
signal activation_failed()

func _ready() -> void:
	
	assert(owner_pawn)
	
	PawnGlobals.pawn_died.connect(_on_pawn_died)

func _enter_tree():
	if not Engine.is_editor_hint(): ModularGlobals.init_modular_node(self)

func _exit_tree():
	if not Engine.is_editor_hint(): ModularGlobals.deinit_modular_node(self)

func _on_pawn_died(in_pawn: Pawn2D, in_immediately: bool) -> void:
	
	var pawn_damage_receiver := DamageReceiver.try_get_from(in_pawn)
	if not pawn_damage_receiver:
		return
	
	if pawn_damage_receiver.LastDamageInstigator == owner_pawn:
		current_charge += charge_per_kill

func can_activate() -> bool:
	if current_charge < 1.0:
		return false
	return is_instance_valid(Pawn2D_Weapon.try_get_from(owner_pawn))

func try_activate() -> void:
	
	if can_activate() or true:
		activated.emit()
		commit_ability()
	else:
		activation_failed.emit()

func apply_cost() -> void:
	current_charge -= 1.0

func apply_cooldown() -> void:
	pass

func commit_ability() -> void:
	
	apply_cost()
	apply_cooldown()
	
	var pawn_weapon := Pawn2D_Weapon.try_get_from(owner_pawn)
	assert(pawn_weapon)
	pawn_weapon.try_use_special_ability()
