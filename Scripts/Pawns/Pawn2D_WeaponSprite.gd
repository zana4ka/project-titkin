extends AnimatedSprite2D
class_name Pawn2D_WeaponSprite

@export_category("Owner")
@export var owner_pawn: Pawn2D
@export var owner_asc: TitkinASC
@export var owner_sprite: Pawn2D_Sprite

#@export_category("Animations")
#@export var animation_player: AnimationPlayer

func _ready() -> void:
	
	assert(owner_pawn)
	assert(owner_asc)
	assert(owner_sprite)
	
	owner_asc.weapons_container_selected_slot_index_changed.connect(_on_selected_slot_index_changed)
	_update_from_weapon_data()
	
	owner_pawn.tree_exited.connect(_on_owner_pawn_tree_exited)

func _on_selected_slot_index_changed() -> void:
	_update_from_weapon_data()

func _on_owner_pawn_tree_exited() -> void:
	if owner_pawn.is_queued_for_deletion():
		queue_free()

func _process(in_delta: float) -> void:
	pass

func _update_from_weapon_data() -> void:
	
	if not owner_asc.weapons_container:
		return
	
	var weapon_data := owner_asc.weapons_container.get_selected_weapon_data()
	
	if weapon_data:
		assert(weapon_data.base_cooldown > 0.0)
		sprite_frames = weapon_data.weapon_sprite_frames
		set_process(true)
	else:
		set_process(false)
		sprite_frames = null
