extends CharacterBody3D

var snowball_speed := 25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_attributes(facing_direction : int, heavy : bool = false):
	velocity = Vector3(snowball_speed * facing_direction, 0,0) * 0.0166
	$MeshInstance3D.mesh.material = StandardMaterial3D.new()
	if heavy:
		await $heavy_hitbox.ready
		$light_hitbox.active = false
		$heavy_hitbox.active = true
		$MeshInstance3D.mesh.material.albedo_color = Color.YELLOW
	else:
		await $heavy_hitbox.ready
		$light_hitbox.active = true
		$heavy_hitbox.active = false

func _physics_process(delta):
	if abs(global_position.x) > 100:
		queue_free
	move_and_collide(velocity)

func _on_hitbox_area_entered(area):
	if area.body.name != get_parent().name:
		queue_free()
