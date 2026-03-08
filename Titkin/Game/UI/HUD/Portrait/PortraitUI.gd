@tool
extends Control
class_name PortraitUI

@export_category("Owner")
@export var owner_hud_ui: HUDUI
@export var portrait_texture: TextureRect

@export_category("Health")
@export var health_fraction_to_variants: Dictionary[float, Texture2D] = {
	1.0: preload("res://Titkin/Game/UI/HUD/Portrait/UI_Kokki001a.png"),
	0.75: preload("res://Titkin/Game/UI/HUD/Portrait/UI_Kokki001b.png"),
	0.4: preload("res://Titkin/Game/UI/HUD/Portrait/UI_Kokki001c.png")
}

@export var preview_health_current: float = 6.0:
	set(in_current): preview_health_current = in_current; _update()

@export var preview_health_max: float = 6.0:
	set(in_max): preview_health_max = in_max; _update()

@export_category("Damage")
@export var damage_animation_player: AnimationPlayer
@export var receive_damage_animation_name: StringName = &"receive_damage"

var wait_pawn_health_changed: WaitForControllerPawnAttributeChanged
var wait_pawn_max_health_changed: WaitForControllerPawnAttributeChanged
var wait_pawn_receive_damage: WaitForControllerPawnReceiveDamage

func _ready() -> void:
	
	if Engine.is_editor_hint():
		set_physics_process(false)
	else:
		assert(owner_hud_ui)
		assert(damage_animation_player)
		assert(not health_fraction_to_variants.is_empty())
		
		wait_pawn_health_changed = WaitForControllerPawnAttributeChanged.new(self, owner_hud_ui.owner_player_controller, AttributeSet.Health)
		wait_pawn_health_changed.attribute_changed.connect(_on_health_changed)
		
		wait_pawn_max_health_changed = WaitForControllerPawnAttributeChanged.new(self, owner_hud_ui.owner_player_controller, AttributeSet.MaxHealth)
		wait_pawn_max_health_changed.attribute_changed.connect(_on_max_health_changed)
		
		wait_pawn_receive_damage = WaitForControllerPawnReceiveDamage.new(self, owner_hud_ui.owner_player_controller)
		wait_pawn_receive_damage.receive_damage.connect(_on_receive_damage)
		
		wait_pawn_receive_damage.ready.connect(_update, Object.CONNECT_DEFERRED)
	
	_update()

func _on_receive_damage(in_source: Node, in_damage: float, in_ignored_immunity_time: bool) -> void:
	damage_animation_player.play(receive_damage_animation_name)

func _on_health_changed(in_old_value: float, in_new_value: float) -> void:
	_update()

func _on_max_health_changed(in_old_value: float, in_new_value: float) -> void:
	_update()

func _update() -> void:
	
	if Engine.is_editor_hint():
		set_health_vaiant(preview_health_current / preview_health_max)
	else:
		if wait_pawn_receive_damage.target_damage_receiver:
			set_health_vaiant(wait_pawn_receive_damage.target_damage_receiver.get_health_fraction())
		else:
			set_health_vaiant(0.0)

func set_health_vaiant(in_fraction: float) -> void:
	
	for sample_fraction: float in health_fraction_to_variants:
		
		if sample_fraction >= in_fraction:
			portrait_texture.texture = health_fraction_to_variants[sample_fraction]
		else:
			pass
