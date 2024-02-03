extends Node3D

func _ready():
	full_body_intangibility(false)

func full_body_intangibility(intangible : bool):
	for child in get_children():
		if child is Area3D:
			child.active = not intangible
