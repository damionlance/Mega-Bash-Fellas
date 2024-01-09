@tool
extends Area3D


@onready var hitcapsule = $HitCapsule
@onready var body = get_parent().get_parent()

@export_range(0.1, 2.0) var hitbox_radius : float = 1.0
@export var active := false
@export_group("Hitbox Properties")
@export_range(0.0, 360.0) var launch_angle : float = 0.0
@export_range(0.1, 50.0) var damage : float = 1.0
@export_range(0, 10) var hitstun_frames : int = 3
@export var knockback : float = 1.0

@export_group("Hurtbox Properties")
@export var hurtbox := false
@export var invincible := false

var collision_spheres := []
var hitbox_point_position = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
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
		$"hitbox point".position.z = 0
		hitcapsule.position = ($"hitbox point").position / 2
		hitcapsule.rotation.z = atan2(($"hitbox point").position.y, ($"hitbox point").position.x) + PI/2
		hitcapsule.shape.height = hitbox_point_position.length()
		hitcapsule.shape.radius = hitbox_radius
		hitbox_point_position = $"hitbox point".position
	else:
		hitcapsule.position = ($"hitbox point").position / 2
		hitcapsule.rotation.z = atan2(($"hitbox point").position.y, ($"hitbox point").position.x) + PI/2
		hitcapsule.shape.height = hitbox_point_position.length()
		hitcapsule.shape.radius = hitbox_radius
		hitbox_point_position = $"hitbox point".position
		if hurtbox:
			monitorable = active
		else:
			monitoring = active



func hit(launch_angle : float, facing_direction : float, damage : float, hitstun_frames : float, knockback : float) :
	body.velocity = Vector3(1, 0, 0).rotated(Vector3(0,0,1),launch_angle)
	body.velocity.x *= facing_direction
	body.velocity *= knockback
	body.emit_signal("has_been_hit", hitstun_frames)
	pass

func _on_area_entered(area):
	if not area.invincible and area.body.name != body.name:
		area.hit(deg_to_rad(launch_angle), body.facing_direction, damage, hitstun_frames, knockback)
