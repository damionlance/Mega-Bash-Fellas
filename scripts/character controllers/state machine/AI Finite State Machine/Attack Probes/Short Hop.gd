extends Area3D

@onready var AI_state_machine = $"../../Controller/State Machine"

func _process(delta):
	for area in get_overlapping_areas():
		if area.body.name == $"../../".name:
			continue
		if AI_state_machine == null:
			AI_state_machine = $"../../Controller/State Machine"
			return
		if not $"../../".is_on_floor():
			return
		if AI_state_machine.current_state.state_name == "Short Hop":
			return
		if abs(area.body.global_position.x - $"../../".global_position.x) - .5 > abs($"../../".velocity.x):
			return
		if area.body.state.current_state.state_name != "Shield":
			AI_state_machine.insert_action("Short Hop")
