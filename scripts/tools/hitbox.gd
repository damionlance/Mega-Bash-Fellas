@tool
extends Area3D

@onready var hitcapsule = $HitCapsule
@export_range(0.1, 2.0) var hitbox_radius : float = 1.0
var collision_spheres := []
var hitbox_point_position = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$"hitbox point".position.z = 0
		hitcapsule.position = ($"hitbox point").position / 2
		hitcapsule.rotation.z = atan2(($"hitbox point").position.y, ($"hitbox point").position.x) + PI/2
		hitcapsule.shape.height = hitbox_point_position.length() + hitcapsule.shape.radius * 2
		hitcapsule.shape.radius = hitbox_radius
		hitbox_point_position = $"hitbox point".position
