@tool
extends Area3D

@onready var hitcapsule = get_child(1)
@onready var body = get_parent().get_parent()

@export_range(0.1, 0.7) var hitbox_radius : float = 1.0
@export var active := false
@export_group("Hitbox Properties")
@export var grab : bool = false
@export var grab_position : Vector3 = Vector3.ZERO
@export_range(0.0, 360.0) var launch_angle : float = 0.0
@export_range(0.1, 50.0) var damage : float = 1.0
@export_range(0, 10) var hitstun_frames : int = 3
@export var knockback : float = 1.0
@export var knockback_scaling : float = 80.0
var collision_spheres := []
var hitbox_point_position = Vector3.ZERO

@export_group("Hurtbox Properties")
@export var hurtbox := false
@export var shield := false
@export var invincible := false
@export var hitbox_start_point : BoneAttachment3D
@export var hitbox_end_point : BoneAttachment3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		hitcapsule.shape = CapsuleShape3D.new()
	else:
		hitcapsule.shape = CapsuleShape3D.new()
	visible = false
	if hurtbox == true:
		set_collision_layer_value(6, true)
		active = true
		monitorable = active
		monitoring = false
	else:
		set_collision_mask_value(6, true)
		active = false
		monitoring = active
		monitorable = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		if not hurtbox:
			$"hitbox point".position.z = 0
			hitcapsule.position = ($"hitbox point").position / 2
			hitcapsule.rotation.z = atan2(($"hitbox point").position.y, ($"hitbox point").position.x) + PI/2
			hitcapsule.shape.height = hitbox_point_position.length()
			hitbox_point_position = $"hitbox point".position
			hitcapsule.shape.radius = hitbox_radius
		elif not shield:
			global_position = hitbox_start_point.global_position
			global_position.z = 0
			var position_of_endpoint = (hitbox_end_point.global_position - global_position)
			position_of_endpoint.z = 0
			hitcapsule.global_position = global_position + (position_of_endpoint / 2)
			hitcapsule.global_position.z = 0
			hitcapsule.rotation.z = atan2(position_of_endpoint.y, position_of_endpoint.x) + PI/2
			hitcapsule.shape.height = position_of_endpoint.length()
			hitcapsule.shape.radius = hitbox_radius
	else:
		if not hurtbox:
			$"hitbox point".position.z = 0
			hitcapsule.position = ($"hitbox point").position / 2
			hitcapsule.rotation.z = atan2(($"hitbox point").position.y, ($"hitbox point").position.x) + PI/2
			hitcapsule.shape.height = hitbox_point_position.length()
			hitbox_point_position = $"hitbox point".position
			hitcapsule.shape.radius = hitbox_radius
			monitoring = active
		elif not shield:
			global_position = hitbox_start_point.global_position
			global_position.z = 0
			var position_of_endpoint = (hitbox_end_point.global_position - global_position)
			hitcapsule.global_position = global_position + (position_of_endpoint / 2)
			hitcapsule.global_position.z = 0
			hitcapsule.rotation.z = atan2(position_of_endpoint.y, position_of_endpoint.x) + PI/2
			hitcapsule.shape.height = position_of_endpoint.length()
			hitcapsule.shape.radius = hitbox_radius
			monitorable = active
		else:
			monitorable = active



func hit(launch_angle : float, facing_direction : float, grab : bool = false, _grab_position : Vector3 = Vector3.ZERO, damage : float = 0.0, hitstun_frames : float = 0.0, knockback : float = 0.0) :
	body.velocity = Vector3(1, 0, 0).rotated(Vector3(0,0,1),launch_angle)
	body.velocity.x *= facing_direction
	body.current_damage += damage * 0.01
	var adjusted_knockback = ( body.current_damage * .1 + body.current_damage * damage / 20)
	adjusted_knockback *= (200/(body.weight + 100)) * 1.4
	adjusted_knockback += 18
	adjusted_knockback *= knockback_scaling * 0.01
	adjusted_knockback += knockback
	body.velocity *= adjusted_knockback
	
	if grab:
		body.facing_direction = -facing_direction
	body.emit_signal("has_been_hit", grab, _grab_position, hitstun_frames)
	
	pass

func _on_area_entered(_area):
	var hit_shield := false
	var hurtbox : Area3D
	for hit_area in get_overlapping_areas():
		if hit_area.shield and not grab:
			hit_shield = true
		elif hit_area.body.name != body.name and not hit_area.invincible:
			hurtbox = hit_area
	if hit_shield: return
	if not hurtbox:
		return
	var adjusted_pos = grab_position
	adjusted_pos.x *= body.facing_direction
	adjusted_pos += body.global_position
	hurtbox.hit(deg_to_rad(launch_angle), body.facing_direction, grab, adjusted_pos, damage, hitstun_frames, knockback)
	if grab:
		body.state.current_state.grab = true
