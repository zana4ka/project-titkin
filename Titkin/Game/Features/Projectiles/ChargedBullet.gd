@tool
extends Projectile2D

@export_category("Charge Modify Targets")
@export var modified_apply_force: Projectile2D_ApplyForce

func _ready() -> void:
	
	super()
	
	if Engine.is_editor_hint():
		pass
	else:
		var source_ability := _source as FirearmUseAbility_Charged
		assert(source_ability)
		
		var charge_time := source_ability.current_charge_time
		
		#assert(modified_apply_force)
		#modified_apply_force.const
