@tool
extends Control
class_name HealthUI

@export_category("Owner")
@export var owner_hud_ui: HUDUI

@export_category("Hearts")
@export var hearts_container: Container
@export var hearts_animation_player: AnimationPlayer
@export var heart_scene: PackedScene = preload("res://Titkin/Game/UI/HUD/Health/HealthUI_Heart.tscn")

@export var preview_hearts_current: float = 1.5:
	set(in_current): preview_hearts_current = in_current; _update()

@export var preview_hearts_max: int = 3:
	set(in_max): preview_hearts_max = in_max; _update()

@export var health_to_heart_ratio: float = 2.0

@export_category("Damage")
@export var receive_damage_animation_name: StringName = &"receive_damage"

var last_max_hearts: int = 0

var wait_pawn_health_changed: WaitForControllerPawnAttributeChanged
var wait_pawn_max_health_changed: WaitForControllerPawnAttributeChanged
var wait_pawn_receive_damage: WaitForControllerPawnReceiveDamage

func _ready() -> void:
	
	if Engine.is_editor_hint():
		set_physics_process(false)
	else:
		assert(hearts_container)
		assert(hearts_animation_player)
		
		wait_pawn_health_changed = WaitForControllerPawnAttributeChanged.new(self, owner_hud_ui.owner_player_controller, AttributeSet.Health)
		wait_pawn_health_changed.attribute_changed.connect(_on_health_changed)
		
		wait_pawn_max_health_changed = WaitForControllerPawnAttributeChanged.new(self, owner_hud_ui.owner_player_controller, AttributeSet.MaxHealth)
		wait_pawn_max_health_changed.attribute_changed.connect(_on_max_health_changed)
		
		wait_pawn_receive_damage = WaitForControllerPawnReceiveDamage.new(self, owner_hud_ui.owner_player_controller)
		wait_pawn_receive_damage.receive_damage.connect(_on_receive_damage)
		
		wait_pawn_receive_damage.ready.connect(_update, Object.CONNECT_DEFERRED)
	
	_update()

func _on_receive_damage(in_source: Node, in_damage: float, in_ignored_immunity_time: bool) -> void:
	hearts_animation_player.play(receive_damage_animation_name)

func _on_health_changed(in_old_value: float, in_new_value: float) -> void:
	_update()

func _on_max_health_changed(in_old_value: float, in_new_value: float) -> void:
	_update()

func _update() -> void:
	
	if Engine.is_editor_hint():
		set_hearts_state(preview_hearts_current, preview_hearts_max)
	else:
		if wait_pawn_receive_damage.target_damage_receiver:
			set_hearts_state(wait_pawn_receive_damage.target_damage_receiver.get_health() / health_to_heart_ratio, ceili(wait_pawn_receive_damage.target_damage_receiver.get_max_health() / health_to_heart_ratio))
		else:
			set_hearts_state(0.0, last_max_hearts)

func set_hearts_state(in_current: float, in_max: int) -> void:
	
	for sample_heart: Control in hearts_container.get_children():
		hearts_container.remove_child(sample_heart)
	
	for sample_index: int in in_max:
		
		var sample_heart := heart_scene.instantiate() as Range
		sample_heart.ratio = minf(in_current - float(sample_index), 1.0)
		hearts_container.add_child(sample_heart)
	last_max_hearts = in_max
