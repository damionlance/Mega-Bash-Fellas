extends Node3D

func reset_hitboxes():
	for child in get_children():
		child.active = false
		child.visible = false
		child.position = Vector3.ZERO
		child.grab = false
