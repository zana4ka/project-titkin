extends Control
class_name VirtualJoystick

## A simple virtual joystick for touchscreens, with useful options.
## Github: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

# EXPORTED VARIABLE

@export var joystick_area: Control
@export var animation_player: AnimationPlayer

## The color of the button when the joystick is pressed.
@export var pressed_color: Color = Color.GRAY

## If the input is inside this range, the output is zero.
@export_range(0.0, 200.0, 1.0) var deadzone_size: float = 10.0

## The max distance the tip can reach.
@export_range(0.0, 500.0, 1.0) var clampzone_size: float = 75.0

enum Joystick_mode {
	FIXED, ## The joystick doesn't move.
	DYNAMIC, ## Every time the joystick area is pressed, the joystick position is set on the touched position.
	FOLLOWING ## When the finger moves outside the joystick area, the joystick will follow it.
}

## If the joystick stays in the same position or appears on the touched position when touch is started
@export var joystick_mode: Joystick_mode = Joystick_mode.FIXED

enum Visibility_mode {
	ALWAYS, ## Always visible
	TOUCHSCREEN_ONLY, ## Visible on touch screens only
	WHEN_TOUCHED ## Visible only when touched
}

## If the joystick is always visible, or is shown only if there is a touchscreen
@export var visibility_mode: Visibility_mode = Visibility_mode.ALWAYS

## If true, the joystick uses Input Actions (Project -> Project Settings -> Input Map)
@export var use_input_actions: bool = true

@export var action_left: String = "Left"
@export var action_right: String = "Right"
@export var action_up: String = "Up"
@export var action_down: String = "Down"

@export var StartEnabled: bool = true
@export var IsMobileOnly: bool = true

# PUBLIC VARIABLES

## If the joystick is receiving inputs.
var is_pressed: bool = false

# The joystick output.
var output: Vector2 = Vector2.ZERO

# PRIVATE VARIABLES

var _touch_index: int = -1

@onready var _base: PositionLerpControl = $Area/Base
@onready var _tip: PositionLerpControl = $Area/Base/Tip

@onready var _RollLabel: VHSFX = $Area/Base/RollLabel

var _base_default_position: Vector2
var _tip_default_position: Vector2

var _default_color: Color

# FUNCTIONS

func _ready() -> void:
	
	if IsMobileOnly and not PlatformGlobals_Class.is_mobile():
		queue_free()
		return
	
	joystick_area.gui_input.connect(HandleAreaInput)
	
	#if ProjectSettings.get_setting("input_devices/pointing/emulate_mouse_from_touch"):
	#	printerr("The Project Setting 'emulate_mouse_from_touch' should be set to False")
	#if not ProjectSettings.get_setting("input_devices/pointing/emulate_touch_from_mouse"):
	#	printerr("The Project Setting 'emulate_touch_from_mouse' should be set to True")
	
	UpdateDefaultValues()
	
	if StartEnabled:
		Enable(true)
	else:
		Disable(true)

func _process(in_delta: float) -> void:
	
	#print(_has_point(get_viewport().get_mouse_position()))
	
	if usage_hint_display_time_left > 0.0:
		
		if TouchIndexWithDragDictionary.is_empty():
			if not animation_player.is_playing():
				animation_player.play(&"UsageHint")
		else:
			if animation_player.is_playing():
				animation_player.stop()
			usage_hint_display_time_left -= in_delta

func _has_point(InPoint: Vector2) -> bool:
	return Rect2(global_position, size).has_point(InPoint)

func UpdateDefaultValues():
	
	_default_color = joystick_area.modulate
	
	if not _base.is_node_ready():
		await _base.ready
	_base_default_position = _base.pending_position
	
	if not _tip.is_node_ready():
		await _tip.ready
	_tip_default_position = _tip.pending_position
	
	_RollLabel.lerp_visible = usage_hint_display_time_left > 0.0
	_reset()

var IsEnabled: bool = false
var usage_hint_display_time_left: float = 0.0:
	set(InTimeLeft):
		
		var PrevShowHint := usage_hint_display_time_left > 0.0
		usage_hint_display_time_left = InTimeLeft
		var NewShowHint := usage_hint_display_time_left > 0.0
		
		if usage_hint_display_time_left > 0.0:
			_RollLabel.lerp_visible = true
		else:
			animation_player.stop()
			_RollLabel.lerp_visible = false
		
		if PrevShowHint != NewShowHint and TouchIndexWithDragDictionary.is_empty():
			reset()

func Enable(InForced: bool = false):
	
	if not is_node_ready() and InForced:
		await ready
	
	if IsEnabled and not InForced:
		return
	
	#set_process_input(true)
	show()
	_reset.call_deferred()
	IsEnabled = true

func Disable(InForced: bool = false):
	
	if not is_node_ready() and InForced:
		await ready
	
	if not IsEnabled and not InForced:
		return
	
	#set_process_input(false)
	hide()
	_reset.call_deferred()
	IsEnabled = false

func reset():
	_reset.call_deferred()

var TouchIndexStartPositionDictionary: Dictionary = {}
var TouchIndexWithDragDictionary: Dictionary = {}

func HandleAreaInput(in_event: InputEvent) -> void:
	
	if in_event is InputEventScreenTouch:
		
		if in_event.is_pressed():
			
			if joystick_mode == Joystick_mode.DYNAMIC or joystick_mode == Joystick_mode.FOLLOWING or (joystick_mode == Joystick_mode.FIXED and _is_point_inside_base(in_event.position)):
				
				TouchIndexStartPositionDictionary[in_event.index] = in_event.position
				
				#if UIGlobals.IsPointInsideControlArea(in_event.position, self) and _touch_index == -1:
				#if _touch_index == -1:
					#WasPressedWithoutDrag = true
					#get_viewport().set_input_as_handled()
					#accept_event()
				get_viewport().set_input_as_handled()
		else:
			
			if TouchIndexStartPositionDictionary.erase(in_event.index):
			#	get_viewport().set_input_as_handled()
				pass
			
			if TouchIndexWithDragDictionary.erase(in_event.index):
				get_viewport().set_input_as_handled()
			
			if in_event.index == _touch_index:
				_reset()
			
	elif in_event is InputEventScreenDrag:
		
		if TouchIndexStartPositionDictionary.has(in_event.index):
			
			#var BaseCenter: Vector2 = _base.pending_position + _get_base_radius()
			var TouchStartPosition := TouchIndexStartPositionDictionary[in_event.index] as Vector2
			
			#var DragStartDistanceSquared := 32.0 * 32.0 if in_event.index == 0 else 128.0 * 128.0
			#if in_event.position.distance_squared_to(TouchStartPosition) > DragStartDistanceSquared:
			if in_event.position.distance_squared_to(TouchStartPosition) > 32.0 * 32.0:
				
				if in_event.index == _touch_index:
					_update_joystick(in_event.position)
				else:
					ActivateJoystickFromInputEvent(in_event)
				
				get_viewport().set_input_as_handled()
				
				## accept_event() blocks other index release input for some reason
				#accept_event()

func ActivateJoystickFromInputEvent(in_event: InputEvent):
	
	if joystick_mode == Joystick_mode.DYNAMIC or joystick_mode == Joystick_mode.FOLLOWING:
		_move_base(in_event.position)
		if _touch_index != -1: ## When dynamically changing touch index
			TouchIndexStartPositionDictionary.erase(_touch_index)
			#TouchIndexStartPositionDictionary[in_event.index] = in_event.position
	
	if visibility_mode == Visibility_mode.WHEN_TOUCHED:
		_base.show()
	
	_touch_index = in_event.index
	TouchIndexWithDragDictionary[in_event.index] = in_event.position
	
	joystick_area.modulate = pressed_color
	_update_joystick(in_event.position)

func _move_base(new_position: Vector2) -> void:
	#_base.global_position = new_position - _base.pivot_offset * get_global_transform_with_canvas().get_scale()
	_base.pending_position = new_position - _base.pivot_offset

func _move_tip(new_position: Vector2) -> void:
	#_tip.global_position = new_position - _tip.pivot_offset * _base.get_global_transform_with_canvas().get_scale()
	_tip.pending_position = new_position - _tip.pivot_offset

func _get_base_radius() -> Vector2:
	return _base.size * 0.5# * _base.get_global_transform_with_canvas().get_scale() / 2

func _is_point_inside_base(point: Vector2) -> bool:
	var _base_radius = _get_base_radius()
	#var center : Vector2 = _base.global_position + _base_radius
	var center : Vector2 = _base.pending_position + _base_radius
	var vector : Vector2 = point - center
	if vector.length_squared() <= _base_radius.x * _base_radius.x:
		return true
	else:
		return false

func _update_joystick(touch_position: Vector2) -> void:
	
	var _base_radius = _get_base_radius()
	var center : Vector2 = _base.pending_position + _base_radius
	
	#print(center, touch_position)
	
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)
	
	if joystick_mode == Joystick_mode.FOLLOWING and touch_position.distance_to(center) > clampzone_size:
		_move_base(touch_position - vector)
	
	_move_tip(_base_radius + vector)
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		is_pressed = false
		output = Vector2.ZERO
	
	if use_input_actions:
		if output.x > 0.0:
			Input.action_release(action_left)
			Input.action_press(action_right, output.x)
		else:
			Input.action_release(action_right)
			Input.action_press(action_left, -output.x)
		
		if output.y > 0.0:
			Input.action_release(action_up)
			Input.action_press(action_down, output.y)
		else:
			Input.action_release(action_down)
			Input.action_press(action_up, -output.y)

func _reset():
	
	if visibility_mode == Visibility_mode.WHEN_TOUCHED and usage_hint_display_time_left <= 0.0:
		_base.hide()
	elif not DisplayServer.is_touchscreen_available() and visibility_mode == Visibility_mode.TOUCHSCREEN_ONLY:
		_base.hide()
	else:
		_base.show()
	
	is_pressed = false
	output = Vector2.ZERO
	_touch_index = -1
	joystick_area.modulate = _default_color
	
	if joystick_mode == Joystick_mode.FIXED:
		_base.pending_position = _base_default_position
	_tip.pending_position = _tip_default_position
	
	_base.ForcePendingPosition()
	#_tip.ForcePendingPosition()
	
	if use_input_actions:
		for action in [action_left, action_right, action_down, action_up]:
			Input.action_release(action)
