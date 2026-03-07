extends Control
class_name SpecialAbilityUI

@export_category("Owner")
@export var owner_hud_ui: HUDUI

@export_category("Charge")
@export var charge_bar: TextureProgressBar

@export_category("Animations")
@export var animation_player: AnimationPlayer
@export var activated_animation_name: StringName = &"activated"
@export var activation_failed_animation_name: StringName = &"activation_failed"

var target_special_charge: Pawn2D_SpecialCharge:
	set(in_special_charge):
		
		if target_special_charge:
			target_special_charge.activated.disconnect(_on_activated)
			target_special_charge.activation_failed.disconnect(_on_activation_failed)
			target_special_charge.current_charge_changed.disconnect(_on_current_charge_changed)
		
		target_special_charge = in_special_charge
		
		if target_special_charge:
			target_special_charge.activated.connect(_on_activated)
			target_special_charge.activation_failed.connect(_on_activation_failed)
			target_special_charge.current_charge_changed.connect(_on_current_charge_changed)
			_on_current_charge_changed()
			visible = true
		else:
			set_process(false)
			visible = false

func _ready() -> void:
	
	assert(owner_hud_ui)
	assert(charge_bar)
	assert(animation_player)
	
	owner_hud_ui.owner_player_controller.controlled_pawn_changed_ready.connect(_on_owner_controlled_pawn_changed)
	_on_owner_controlled_pawn_changed()

func _process(in_delta: float) -> void:
	
	if is_equal_approx(charge_bar.value, target_special_charge.current_charge):
		set_process(false)
	else:
		charge_bar.value = move_toward(charge_bar.value, target_special_charge.current_charge, 1.6 * in_delta)

func _on_owner_controlled_pawn_changed() -> void:
	target_special_charge = Pawn2D_SpecialCharge.try_get_from(owner_hud_ui.owner_player_controller.controlled_pawn)

func _on_current_charge_changed() -> void:
	set_process(true)

func _on_activated() -> void:
	animation_player.stop()
	animation_player.play(activated_animation_name)

func _on_activation_failed() -> void:
	animation_player.stop()
	animation_player.play(activation_failed_animation_name)
