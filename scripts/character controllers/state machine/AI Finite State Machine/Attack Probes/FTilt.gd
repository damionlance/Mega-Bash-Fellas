extends Area3D

@onready var AI_state_machine = $"../../Controller/State Machine"

func _on_area_entered(area):
	if area.body.name == $"../../".name:
		return
	if AI_state_machine == null:
		AI_state_machine = $"../../Controller/State Machine"
		return
	if not $"../../".is_on_floor():
		return
	if abs($"../../".velocity.x) > 5:
		return
	
	if area.body.state.current_state.state_name != "Shield":
		AI_state_machine.update_state("FTilt")
