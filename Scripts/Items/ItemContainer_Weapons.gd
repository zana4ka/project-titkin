extends ItemContainer
class_name ItemContainer_Weapons

var selected_slot_index: int:
	set(in_index):
		selected_slot_index = in_index
		selected_slot_index_changed.emit(selected_slot_index)
signal selected_slot_index_changed(in_index: int)

func _ready() -> void:
	
	super()
	
	if WorldGlobals._level is RGLevelBase2D:
		remove_all_items()
		try_add_item(load("res://Assets/Items/Firearms/Pistols/LaserGun001.tres"))
		try_add_item(load("res://Assets/Items/Firearms/Pistols/BalloonDeagle001.tres"))
		try_add_item(load("res://Assets/Items/Firearms/Pistols/BonyRevolver001.tres"))
		#try_add_item(load("res://Assets/Items/Firearms/SMGs/Tompson001.tres"))
	#elif WorldGlobals._level is BULevelBase2D:
	#	remove_all_items()
	#	try_add_item(load("res://Assets/Items/Melee/PlayerFists001.tres"))

func get_items_array_as_weapons() -> Array[ItemData_Weapon]:
	var out_weapons: Array[ItemData_Weapon] = []
	for sample_data: ItemData_Weapon in _items_num_dictionary.keys():
		out_weapons.append(sample_data)
	return out_weapons

func get_selected_weapon_data() -> ItemData_Weapon:
	
	var weapons := get_items_array_as_weapons()
	if GameGlobals_Class.ArrayIsValidIndex(weapons, selected_slot_index):
		return weapons[selected_slot_index]
	else:
		return null

func try_select_weapon(in_index: int) -> bool:
	
	var slots_num := get_slots_num_max()
	if slots_num == 0:
		return false
	
	selected_slot_index = wrapi(in_index, 0, slots_num)
	return true
