extends AnimatedSprite2D
class_name Pawn2D_Weapon

@export_category("Owner")
@export var owner_pawn: Pawn2D
@export var owner_sprite: Pawn2D_Sprite

@export_category("Item")
@export var weapon_data: ItemData_Weapon

var fire_rate_time_left: float = 0.0

func _ready() -> void:
	fire_rate_time_left = weapon_data.base_fire_rate

func _process(in_delta: float) -> void:
	
	fire_rate_time_left -= in_delta
	
	if fire_rate_time_left > 0.0:
		pass
	else:
		fire_projectile()
		fire_rate_time_left += weapon_data.base_fire_rate

func fire_projectile() -> void:
	
	var projectile_rotation := global_rotation
	if owner_sprite._Direction == AnimationData2D.Direction.Left:
		projectile_rotation = (PI - projectile_rotation)
	
	var _projectile := Projectile2D.spawn(Transform2D(projectile_rotation, global_position), weapon_data.projectile_data, 0, owner_pawn)
