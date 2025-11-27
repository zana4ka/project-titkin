extends AnimatedSprite2D
class_name Pawn2D_Weapon

@export_category("Owner")
@export var owner_pawn: Pawn2D
@export var owner_sprite: Pawn2D_Sprite

@export_category("Item")
@export var weapon_data: ItemData_Weapon
@export var should_update_from_weapons_container: bool = false

@export_category("Input")
@export var is_holding_use_input: bool = false:
	set(in_is_holding):
		
		if in_is_holding != is_holding_use_input:
			is_holding_use_input = in_is_holding
			_on_is_holding_use_input_changed()

@export_category("Animations")
@export var animation_player: AnimationPlayer

var hold_weapon_uses_counter: int = 0

var use_cooldown_time_left: float = 0.0:
	set(in_time_left):
		use_cooldown_time_left = in_time_left
		set_process(use_cooldown_time_left > 0.0)

var target_weapons_container: ItemContainer_Weapons

func _ready() -> void:
	
	owner_pawn.controller_changed.connect(_on_controller_changed)
	_on_controller_changed()
	
	owner_pawn.controller_tap_input.connect(_on_controller_tap_input)
	_update_from_weapon_data()

func _process(in_delta: float) -> void:
	
	use_cooldown_time_left -= in_delta
	
	if use_cooldown_time_left > in_delta:
		pass
	else:
		handle_use_cooldown_finished()

func _update_from_weapon_data() -> void:
	
	if weapon_data:
		assert(weapon_data.base_cooldown > 0.0)
		use_cooldown_time_left = weapon_data.base_cooldown
		sprite_frames = weapon_data.weapon_sprite_frames
	else:
		set_process(false)
		sprite_frames = null

func try_use_weapon() -> bool:
	
	if not is_instance_valid(weapon_data) and not is_instance_valid(owner_pawn):
		return false
	
	if use_cooldown_time_left > 0.0:
		return false
	
	weapon_data.handle_use(self)
	use_cooldown_time_left += weapon_data.base_cooldown
	return true

func handle_use_cooldown_finished() -> void:
	
	if not weapon_data:
		return
	
	match weapon_data.use_input_mode:
		ItemData_Weapon.UseInputMode.Auto:
			try_use_weapon()
		ItemData_Weapon.UseInputMode.Hold:
			if is_holding_use_input: try_use_weapon()
		ItemData_Weapon.UseInputMode.Single:
			pass

func _on_controller_tap_input(in_screen_position: Vector2, in_global_position: Vector2, in_released: bool) -> void:
	
	if not weapon_data:
		return
	
	match weapon_data.use_input_mode:
		
		ItemData_Weapon.UseInputMode.Auto:
			pass
		ItemData_Weapon.UseInputMode.Hold:
			is_holding_use_input = not in_released
		ItemData_Weapon.UseInputMode.Single:
			try_use_weapon()

func _on_controller_changed() -> void:
	
	if not should_update_from_weapons_container:
		return
	
	if target_weapons_container:
		target_weapons_container.selected_slot_index_changed.disconnect(_on_weapons_container_selected_slot_index_changed)
	
	target_weapons_container = ModularGlobals.try_get_from(owner_pawn.controller, ItemContainer_Weapons)
	
	if target_weapons_container:
		target_weapons_container.selected_slot_index_changed.connect(_on_weapons_container_selected_slot_index_changed)
	update_from_weapons_container()

func _on_weapons_container_selected_slot_index_changed(in_index: int) -> void:
	update_from_weapons_container()

func update_from_weapons_container() -> void:
	weapon_data = target_weapons_container.get_selected_weapon_data()

func _on_is_holding_use_input_changed() -> void:
	
	if is_holding_use_input:
		try_use_weapon()
	else:
		hold_weapon_uses_counter = 0
