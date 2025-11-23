@tool
extends Projectile2D

@export_category("Pattern Variations")
@export var pattern_apply_force: Projectile2D_ApplyForce
@export var pattern_from_hold_num: int = 2

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		assert(pattern_apply_force)
		
		var this_bullet_num := get_meta(Pawn2D_Weapon.hold_projectile_num_meta, 0) as int
		if this_bullet_num >= pattern_from_hold_num:
			pass
		else:
			pattern_apply_force.PatternDirectionCurve = null
