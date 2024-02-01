extends Node3D

func full_body_intangibility(intangible : bool):
	for child in get_children():
		if child is Area3D:
			child.active = not intangible
