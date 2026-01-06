extends AbilitySystemComponent
class_name TitkinASC

func _ready() -> void:
	
	super()
	
	if weapons_container:
		pass
	else:
		owner_pawn.controller_changed.connect(_on_owner_controller_changed)
		_on_owner_controller_changed()
	
	weapons_container_selected_slot_index_changed.connect(_update_equipped_weapon)
	_update_equipped_weapon()

func _on_owner_controller_changed() -> void:
	_update_weapons_container_from_owner_controller()

##
## Items
##
@export_category("Items")
@export var weapons_container: ItemContainer_Weapons

signal weapons_container_changed()
signal weapons_container_selected_slot_index_changed()

func _update_weapons_container_from_owner_controller() -> void:
	
	if weapons_container:
		weapons_container.selected_slot_index_changed.disconnect(_on_weapons_container_selected_slot_index_changed)
	
	weapons_container = ModularGlobals.try_get_from(owner_pawn.controller, ItemContainer_Weapons)
	weapons_container_changed.emit()
	
	if weapons_container:
		weapons_container.selected_slot_index_changed.connect(_on_weapons_container_selected_slot_index_changed)
		weapons_container_selected_slot_index_changed.emit()

func _on_weapons_container_selected_slot_index_changed(in_index: int) -> void:
	weapons_container_selected_slot_index_changed.emit()

var _current_equipped_weapon_ability: GameplayAbility

func _update_equipped_weapon() -> void:
	
	if _current_equipped_weapon_ability:
		remove_ability(_current_equipped_weapon_ability)
		_current_equipped_weapon_ability = null
	
	var current_weapon_data := weapons_container.get_selected_weapon_data()
	if current_weapon_data:
		var use_ability_script := current_weapon_data.get_use_ability_script()
		if use_ability_script:
			_current_equipped_weapon_ability = give_ability(use_ability_script)
