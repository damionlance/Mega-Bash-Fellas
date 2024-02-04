extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_parent().ready
	print(get_parent().player_number)
	for mesh in $"rig/Skeleton3D/".get_children():
		mesh.set_surface_override_material(0, $"rig/Skeleton3D/Body".get_surface_override_material(0).duplicate())
		if get_parent().player_number == 1:
			mesh.get_surface_override_material(0).albedo_color = Color.BLUE
		if get_parent().player_number == 2:
			mesh.get_surface_override_material(0).albedo_color = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
