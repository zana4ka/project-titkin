@tool
extends Control
class_name WeaponsUI

@export_category("Owner")
@export var owner_hud_ui: HUDUI

@export_category("Slots")
@export var slots_container: Container
@export var slots_animation_player: AnimationPlayer
@export var slot_scene: PackedScene = preload("res://Scenes/UI/HUD/WeaponsUI_Slot.tscn")

@export var preview_selected_slot: int = 0:
	set(in_slot): preview_selected_slot = in_slot; _update_selection(preview_selected_slot)

@export var preview_slots_data: Array[ItemData_Weapon] = []:
	set(in_data): preview_slots_data = in_data; _update_full()

@export var preview_slots_max: int = 3:
	set(in_max): preview_slots_max = in_max; _update_full()

@export var health_to_heart_ratio: float = 1.0

var last_max_hearts: int = 0

func _ready() -> void:
	
	if Engine.is_editor_hint():
		set_physics_process(false)
	else:
		assert(slots_container)
		assert(slots_animation_player)
		
		var weapons_container := ModularGlobals.try_get_from(owner_hud_ui.owner_player_controller, ItemContainer_Weapons) as ItemContainer_Weapons
		weapons_container.items_changed.connect(_on_weapons_container_items_changed)
		weapons_container.selected_slot_index_changed.connect(_on_weapons_container_selected_slot_changed)
	
	_update_full()

func _update_full() -> void:
	
	if Engine.is_editor_hint():
		update_slots_data(preview_slots_data, preview_slots_max)
		_update_selection(preview_selected_slot)
	else:
		var weapons_container := ModularGlobals.try_get_from(owner_hud_ui.owner_player_controller, ItemContainer_Weapons) as ItemContainer_Weapons
		update_slots_data(weapons_container.get_items_array_as_weapons(), weapons_container.get_slots_num_max())
		_update_selection(weapons_container.selected_slot_index)

func _update_selection(in_index: int) -> void:
	
	for sample_index: int in slots_container.get_child_count():
		var sample_slot := slots_container.get_child(sample_index) as WeaponsUI_Slot
		sample_slot.is_selected = (sample_index == in_index)

func update_slots_data(in_slots_data: Array[ItemData_Weapon], in_max: int) -> void:
	
	for sample_slot: WeaponsUI_Slot in slots_container.get_children():
		slots_container.remove_child(sample_slot)
	
	for sample_index: int in in_max:
		
		var sample_slot := slot_scene.instantiate() as WeaponsUI_Slot
		if sample_index < in_slots_data.size():
			sample_slot.set_data(in_slots_data[sample_index])
		else:
			sample_slot.set_data(null)
		slots_container.add_child(sample_slot)

func _on_weapons_container_items_changed() -> void:
	_update_full()

func _on_weapons_container_selected_slot_changed(in_index: int) -> void:
	_update_selection(in_index)
