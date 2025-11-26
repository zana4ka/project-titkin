extends AnimatedSprite2D
class_name Pawn2D_Weapon

@export_category("Owner")
@export var owner_pawn: Pawn2D
@export var owner_sprite: Pawn2D_Sprite

@export_category("Item")
@export var weapon_data: ItemData_Weapon
@export var should_update_from_weapons_container: bool = false

@export_category("Input")
@export var is_holding_fire_input: bool = false:
	set(in_is_holding):
		
		if in_is_holding != is_holding_fire_input:
			
			is_holding_fire_input = in_is_holding
			
			if is_holding_fire_input:
				try_fire_projectile()
			else:
				hold_projectiles_fired_counter = 0

var hold_projectiles_fired_counter: int = 0
const hold_projectile_num_meta: StringName = &"Pawn2D_Weapon_hold_projectile_num"

var fire_cooldown_time_left: float = 0.0:
	set(in_time_left):
		fire_cooldown_time_left = in_time_left
		set_process(fire_cooldown_time_left > 0.0)

var target_weapons_container: ItemContainer_Weapons

func _ready() -> void:
	
	owner_pawn.controller_changed.connect(_on_controller_changed)
	_on_controller_changed()
	
	owner_pawn.controller_tap_input.connect(_on_controller_tap_input)
	_update_from_weapon_data()

func _process(in_delta: float) -> void:
	
	fire_cooldown_time_left -= in_delta
	
	if fire_cooldown_time_left > in_delta:
		pass
	else:
		handle_fire_cooldown_finished()

func _update_from_weapon_data() -> void:
	
	if weapon_data:
		assert(weapon_data.base_fire_rate > 0.0)
		fire_cooldown_time_left = weapon_data.base_fire_rate
		sprite_frames = weapon_data.weapon_sprite_frames
	else:
		set_process(false)
		sprite_frames = null

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

func _on_controller_tap_input(in_screen_position: Vector2, in_global_position: Vector2, in_released: bool) -> void:
	
	match weapon_data.fire_input_mode:
		
		ItemData_Weapon.FireInputMode.Auto:
			pass
		ItemData_Weapon.FireInputMode.Hold:
			is_holding_fire_input = not in_released
		ItemData_Weapon.FireInputMode.Single:
			try_fire_projectile()

func try_fire_projectile() -> Projectile2D:
	
	if not is_instance_valid(owner_pawn):
		return null
	
	if fire_cooldown_time_left > 0.0:
		return null
	
	var projectile_rotation := global_rotation
	if owner_sprite._Direction == AnimationData2D.Direction.Left:
		projectile_rotation = (PI - projectile_rotation)
	
	var _projectile := Projectile2D.spawn(Transform2D(projectile_rotation, global_position), weapon_data.projectile_data, 0, owner_pawn)
	
	if weapon_data.is_hold_fire_input_mode():
		hold_projectiles_fired_counter += 1
		_projectile.set_meta(hold_projectile_num_meta, hold_projectiles_fired_counter)
	
	fire_cooldown_time_left += weapon_data.base_fire_rate
	return _projectile

func handle_fire_cooldown_finished() -> void:
	
	match weapon_data.fire_input_mode:
		ItemData_Weapon.FireInputMode.Auto:
			try_fire_projectile()
		ItemData_Weapon.FireInputMode.Hold:
			if is_holding_fire_input:
				try_fire_projectile()
		ItemData_Weapon.FireInputMode.Single:
			pass
