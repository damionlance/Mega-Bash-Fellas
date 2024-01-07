extends Area3D

@onready var state := $"../State Machine"

func _on_area_exited(area):
	state.update_state("Respawn")
	pass
