extends Area3D

@onready var AI_state_machine = $"../../Controller/State Machine"

func _process(delta):
	for area in get_overlapping_areas():
		if area.body.name == $"../../".name:
			continue
		if AI_state_machine == null:
			AI_state_machine = $"../../Controller/State Machine"
			return
		if abs($"../../".velocity.x) > 5:
			return
		
		if area.body.state.current_state.state_name != "Shield":
			AI_state_machine.insert_action("Jab")
