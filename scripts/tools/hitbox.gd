@tool
extends Area3D

@onready var hitcapsule = get_child(1)
@onready var body = get_parent().get_parent()

@export_range(0.1, 0.7) var hitbox_radius : float = 1.0
@export var active := false
@export_group("Hitbox Properties")
@export_range(0.0, 360.0) var launch_angle : float = 0.0
@export_range(0.1, 50.0) var damage : float = 1.0
@export_range(0, 10) var hitstun_frames : int = 3
@export var knockback : float = 1.0
var collision_spheres := []
var hitbox_point_position = Vector3.ZERO

@export_group("Hurtbox Properties")
@export var hurtbox := false
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
		else:
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
		else:
			global_position = hitbox_start_point.global_position
			global_position.z = 0
			var position_of_endpoint = (hitbox_end_point.global_position - global_position)
			hitcapsule.global_position = global_position + (position_of_endpoint / 2)
			hitcapsule.global_position.z = 0
			hitcapsule.rotation.z = atan2(position_of_endpoint.y, position_of_endpoint.x) + PI/2
			hitcapsule.shape.height = position_of_endpoint.length()
			hitcapsule.shape.radius = hitbox_radius
			monitorable = active



func hit(launch_angle : float, facing_direction : float, damage : float, hitstun_frames : float, knockback : float) :
	body.velocity = Vector3(1, 0, 0).rotated(Vector3(0,0,1),launch_angle)
	body.velocity.x *= facing_direction
	body.velocity *= knockback
	body.emit_signal("has_been_hit", hitstun_frames)
	pass

func _on_area_entered(area):
	if not area.invincible and area.body.name != body.name:
		area.hit(deg_to_rad(launch_angle), body.facing_direction, damage, hitstun_frames, knockback)
