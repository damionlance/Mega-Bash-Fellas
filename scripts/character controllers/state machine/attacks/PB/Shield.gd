extends GroundedMovement


#private variables
var state_name = "Shield"

var can_drop_thru_platform := false
var can_dash := false
@onready var shield := $"../../../Shield"
@export var mid_point := Vector3.UP
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	if controller.movement_direction.y > -.4:
		can_drop_thru_platform = true
	if controller.movement_direction.length() == 0:
		can_dash = true
	
	var delta_v = Vector2.ZERO
	
	# Handle all states
	if controller.shield_state == 0:
		state.update_state("Idle")
		shield.visible = false
		return
	if controller.attempting_attack:
		decide_attack()
	if controller.attempting_jump:
		state.update_state("Jump Squat")
		shield.visible = false
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		shield.visible = false
		return
	if controller.crush_direction.y < -0.8 and controller.movement_direction.y < -0.8:
		passthru_platform_checker.drop_thru_platform()
		state.update_state("Drop Through Platform")
		shield.visible = false
		return
	animation_tree["parameters/AnimationNodeStateMachine/Grounded Movement/Shield/blend_position"] = controller.crush_direction
	shield.global_position = body.global_position + Vector3(controller.crush_direction.x, controller.crush_direction.y, 0) + mid_point
	if abs(controller.movement_direction.x) > controller.neutral_zone:
		pass # INSERT DODGE STUFF HERE
	# Process inputs
	
	# Handle all relevant timers
	# Process physics
	pass

func reset(_delta):
	shield.global_position = body.global_position + Vector3(controller.crush_direction.x, controller.crush_direction.y, 0) + mid_point
	shield.visible = true
	body.velocity = Vector3.ZERO
	body.delta_v = Vector2.ZERO
	body.attacking = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
