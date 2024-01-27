extends GroundedMovement


#private variables
var state_name = "Shield"

var can_drop_thru_platform := false
var can_dodge := false

var drop_shield = false
@export var animation_finished = false
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
		can_dodge = true
	
	var delta_v = Vector2.ZERO
	
	# Handle all states
	if animation_finished:
		state.update_state("Idle")
		return
	
	if Input.get_axis("Left","Right") > .8 and can_dodge:
		state.update_state("Dodge Roll")
		shield.visible = false
		return
	if not Input.is_action_pressed("Shield"):
		can_dodge = false
		drop_shield = true
		shield.visible = false
		return
	if Input.is_action_just_pressed("Jump"):
		state.update_state("Jump Squat")
		shield.visible = false
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		shield.visible = false
		return
	if Input.is_action_pressed("Attack"):
		animation_tree["parameters/StateMachine/General State/Grounded Movement/Shield/Shield/blend_position"] = controller.movement_direction
		can_dodge = false
		shield.global_position = body.global_position + Vector3(controller.movement_direction.x, controller.movement_direction.y, 0) + mid_point
	elif Input.get_action_strength("Down") < -0.8 and not can_dodge:
		passthru_platform_checker.drop_thru_platform()
		state.update_state("Drop Through Platform")
		shield.visible = false
		return
	# Process inputs
	
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	body.slide_off_ledge = false
	animation_finished = false
	drop_shield = false
	can_dodge = false
	
	shield.visible = true
	body.velocity = Vector3.ZERO
	body.delta_v = Vector2.ZERO
	body.attacking = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
